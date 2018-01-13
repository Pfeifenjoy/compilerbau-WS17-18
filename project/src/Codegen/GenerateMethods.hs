{-# LANGUAGE TemplateHaskell #-}

{-|
This module generates the code for all methods except the <init> method
of a class file
-}
module Codegen.GenerateMethods (
  genMethods,
  visToFlag,
  typeToDescriptor,
  iconst,
  split16Byte
) where
import ABSTree
import qualified Codegen.Data.MethodFormat as MF
import qualified Data.HashMap.Lazy as HM
import Data.Bits
import Codegen.Data.MethodFormat hiding (Return, New)
import Codegen.Data.ClassFormat
import Codegen.GenerateConstantPool
import Control.Lens
import Control.Arrow
import Control.Monad
import Control.Monad.Trans.State.Lazy

-- TODO combine user defined init method with default init method

-- | The name of a local variable.  It is the name in the source code
--   followed by the deepness in a nested block
type LocVarName = String

-- | The index of a local variable in the heap
type LocVarIndex = Int

-- | The line number in the assembler code
type LineNumber = Int

data Vars = Vars { -- | maps the index of a local Variable to its name.
                   _localVar :: HM.HashMap LocVarIndex LocVarName
                 , _classFile :: ClassFile
                 , _deepness :: Int -- ^ deepness of nested block
                 , _curStack :: Int
                 , _maxStack :: Int
                 , _line :: LineNumber
                 -- | Stack of lines to which break should jump
                 , _continueLine :: [LineNumber]
                 }
makeLenses ''Vars

genMethods :: [MethodDecl] -> State ClassFile ()
genMethods mds
  = modify (set countMethods (length mds)) >> mapM_ genMethod mds

genMethod ::  MethodDecl -> State ClassFile ()
genMethod (MethodDecl name typ argDecls stmt vis static) =
  do indexName <- genUTF8 name
     let getArgDesr (ArgumentDecl _ typ _) = typeToDescriptor typ
         descr = "(" ++ concatMap getArgDesr argDecls ++ ")"
                     ++ typeToDescriptor typ
     indexType <- genUTF8 descr
     indexCode <- genUTF8 "Code"
     cf <- get
     let (code,vars)
           = runState (codeToInt <$> genCodeStmt stmt)
                      Vars { _localVar = HM.fromList $ (0, "This")
                                          : zip [1..]
                                            (map
                                              (\(ArgumentDecl n _ _) -> n)
                                              argDecls)
                           , _classFile = cf
                           , _deepness = 0
                           , _curStack = 0
                           , _maxStack = 0
                           , _line = 0
                           , _continueLine = []
                           }
     put $ vars^.classFile
     let accessFlags = visToFlag vis : [8 | static]
         codeAttr = AttributeCode { _indexNameAttr = indexCode
                                  , _tamLenAttr = 16 + vars^.line
                                  , _lenStackAttr = vars^.maxStack
                                  , _lenLocalAttr = length $ vars^.localVar
                                  , _tamCodeAttr = vars^.line
                                  , _arrayCodeAttr = code
                                  , _tamExAttr = 0
                                  , _arrayExAttr = []
                                  , _tamAtrrAttr = 0
                                  , _arrayAttrAttr = []
                                  }
         methodInfo = MethodInfo { _afMi = AccessFlags accessFlags
                                 , _indexNameMi = indexName
                                 , _indexDescrMi = indexType
                                 , _tamMi = 1
                                 , _arrayAttrMi = [codeAttr]
                                 }
     modify $ over arrayMethods (methodInfo:)

genCodeStmt :: Stmt -> State Vars Code
-- Block
genCodeStmt (Block stmts) =
  do modify $ over deepness (+1)
     code <- foldr ((-++-) . genCodeStmt) (return []) stmts
     modify $ over deepness (\x -> x-1)
     return code

-- Return
genCodeStmt (TypedStmt (Return expr) typ) =
  do exprCode <- genCodeExpr expr
     modify $ over line (+1) -- length of Ireturn
     return $ exprCode ++ (case typ of
                             -- TODO check types
                             "objectref" -> [Areturn]
                             "double" -> [Dreturn]
                             "float" -> [Freturn]
                             "int" -> [Ireturn]
                             "bool" -> [Ireturn]
                             "char" -> [Ireturn]
                             "long" -> [Lreturn]
                             "void" -> [MF.Return])


-- While
genCodeStmt (While cond body) =
  do (refLine,condCode,bodyCode) <- getForWhileCode cond body
     modify $ over line (+3) -- length of Goto
     breakLine <- (+1) . view line <$> get
     let (b1,b2) = split16Byte . twoCompliment16 $ breakLine - refLine
         (b3,b4) = split16Byte . twoCompliment16 $ refLine - breakLine - 1
         code = condCode ++ [Ifeq b1 b2]
                         ++ adBreaks refLine breakLine bodyCode
                         ++ [Goto b3 b4]
     modify $ over continueLine tail
     return code

-- DoWhile
genCodeStmt (DoWhile cond body) =
  do refLine <- (+1) . view line <$> get
     modify $ over continueLine (refLine:)
     bodyCode <- genCodeStmt body
     condCode <- genCodeExpr cond
     modify $ over line (+3) -- length of Ifne
     breakLine <- (+1) . view line <$> get
     let (b1,b2) = split16Byte . twoCompliment16  $ breakLine - refLine
         code = adBreaks refLine breakLine bodyCode ++ condCode
                                                    ++ [Ifne b1 b2]
     modify $ over continueLine tail
     return code

-- For
genCodeStmt (For init cond iter body) =
  do initialCode <- genCodeStmt init -- i.e. i = 1
     (refLine,condCode,bodyCode) <- getForWhileCode cond body
     iterateCode <- genCodeStmt iter -- i.e. i++
     modify (over line (+3)) -- Goto b1 b2
     breakLine <- view line <$> get
     let (b1,b2) = split16Byte . twoCompliment16  $ breakLine - refLine
         (b3,b4) = split16Byte . twoCompliment16  $ refLine - breakLine - 1
         code = initialCode ++ condCode
                            ++ [Ifeq b1 b2]
                            ++ adBreaks refLine breakLine bodyCode
                            ++ iterateCode
                            ++ [Goto b3 b4]
     modify $ over continueLine tail
     return code

genCodeStmt Break =
  do modify $ over line (+3)
     return [Goto 0 0]

genCodeStmt Continue =
  do modify $ over line (+3)
     refLine <- (+1) . view line <$> get
     conLine <- head . view continueLine <$> get
     let (b1,b2) = split16Byte . twoCompliment16  $ conLine - refLine
     return [Goto b1 b2]

genCodeStmt (If cond bodyIf (Just bodyElse)) =
  do condCode <- genCodeExpr cond
     ref <- (+1) . view line <$> get
     modify $ over line (+3) -- length of Ifeq
     bodyIfCode <- genCodeStmt bodyIf
     endIf <- view line <$> get
     modify $ over line (+1)
     bodyElseCode <- genCodeStmt bodyElse
     endElse <- view line <$> get
     let (b1,b2) = split16Byte . twoCompliment16 $ endIf + 4 - ref
         (b3,b4) = split16Byte . twoCompliment16  $ endElse - endIf
     return $ condCode ++ [Ifeq b1 b2] ++ bodyIfCode ++ [Goto b3 b4]
                       ++ bodyElseCode

genCodeStmt (If cond body Nothing) =
  do ref <- (+1) . view line <$> get
     (condCode,bodyCode) <- getCondBodyCode cond body
     endIf <- view line <$> get
     let (b1,b2) = split16Byte . twoCompliment16 $ endIf - ref
     return $ condCode ++ [Ifeq b1 b2] ++ bodyCode

genCodeStmt (Switch expr switchCases (Just stmts)) = undefined
genCodeStmt (Switch expr switchCases Nothing) = undefined
genCodeStmt (LocalVarDecls vds)
  = foldr ((-++-) . genCodeVarDecl) (return []) vds
genCodeStmt (StmtExprStmt stmtExpr) = undefined
genCodeStmt (TypedStmt stmt _) = genCodeStmt stmt

genCodeExpr :: Expr -> State Vars Code
genCodeExpr This = undefined
genCodeExpr (LocalOrFieldVar str) = undefined
genCodeExpr (InstVar expr str) = undefined
genCodeExpr (Unary str expr) = undefined
genCodeExpr (Binary "+" expr1 expr2)
  = genCodeExpr expr1
    -++- genCodeExpr expr2
    -++- (modify (over line (+1)) >> modifyStack (-1) >> return [Iadd])
genCodeExpr (Binary "-" expr1 expr2) = undefined
-- TODO add Isub to assembler
--  = genCodeExpr expr1
--    -++- genCodeExpr expr2
--    -++- (modify (over line (+1)) >> modiyStack (-1) >> return [Isub])
genCodeExpr (InstanceOf expr typ) = undefined
    -- TODO extra instanceOf
-- expr1 ? expr2 : expr3 cf = undefined
genCodeExpr (Ternary expr1 expr2 expr3) = undefined
genCodeExpr (BooleanLiteral True)
  = modify (over line (+1)) >> return [Iconst1]
genCodeExpr (BooleanLiteral False)
  = modify (over line (+1)) >> return [Iconst0]
genCodeExpr (CharLiteral char) = undefined
genCodeExpr (IntegerLiteral int)
  = modify (over line (+1)) >> return [iconst $ fromIntegral int]
    --  LongLiteral Int64
    --  FloatLiteral Float
    --  DoubleLiteral Double
    --  StringLiteral String
genCodeExpr JNull = undefined
genCodeExpr (StmtExprExpr sE) = genCodeStmtExpr sE
genCodeExpr (TypedExpr expr _) = genCodeExpr expr

genCodeVarDecl :: VariableDecl -> State Vars Code
genCodeVarDecl (VariableDecl _ _ _ Nothing) = return []
genCodeVarDecl (VariableDecl name typ _ (Just value)) = undefined

genCodeStmtExpr :: StmtExpr -> State Vars Code
genCodeStmtExpr (Assign (LocalOrFieldVar name) expr) = undefined
genCodeStmtExpr (New typ  arguments) = undefined
genCodeStmtExpr (MethodCall expr name arguments) = undefined
genCodeStmtExpr (LazyAssign (LocalOrFieldVar name) expr) = undefined
genCodeStmtExpr (TypedStmtExpr se _) = genCodeStmtExpr se

genCodeSwitchCase :: SwitchCase -> State Vars Code
genCodeSwitchCase (SwitchCase expr cases) = undefined


-- helper functions

getForWhileCode :: Expr -> Stmt -> State Vars (LineNumber,Code,Code)

getForWhileCode cond body =
  do refLine <- (+1) . view line <$> get
     modify $ over continueLine (refLine:)
     (condCode,bodyCode) <- getCondBodyCode cond body
     return (refLine,condCode,bodyCode)

getCondBodyCode :: Expr -> Stmt -> State Vars (Code,Code)
getCondBodyCode cond body =
  do condCode <- genCodeExpr cond
     modify (over line (+3)) -- jump + 2 branch bytes
     bodyCode <- genCodeStmt body
     return (condCode,bodyCode)

-- | put n items on the opstack.  calculates new max stack depth
modifyStack :: Int -> State Vars ()
modifyStack n = do modify $ over curStack (+n)
                   cur <- (view curStack) <$> get
                   curMax <- (view maxStack) <$> get
                   modify $ set maxStack $ max cur curMax


-- | split a unsigned 16 bits int in two signed 8 bits int
split16Byte :: (Bits n,Integral n) => n -- ^ 16 Byte
                                   -> (n -- ^ upper 8 byte
                                      ,n) -- ^ lower 8 byte
split16Byte i = (div i (2^8),mod i (2^8))


-- TODO make sure that's correct
-- | makes the two complement of a 16 bits int
twoCompliment16 :: (Bits n,Num n) => n -> n
twoCompliment16 i = -(i .&. mask) + (i .&. complement mask)
  where mask = 2^(16-1)

-- | ads the lines to jump to the Goto
adBreaks :: LineNumber -- ^ current line in code
         -> LineNumber -- ^ line to jump to
         -> Code -- ^ code without right break references
         -> Code -- ^ code with right break references
adBreaks refIndex index [] = []
adBreaks refIndex index (Goto 0 0:as)
  = Goto b1 b2: adBreaks (refIndex + 1) index as
      where (b1,b2) = split16Byte . twoCompliment16 $ index - refIndex
adBreaks refIndex index (a:as) = a : adBreaks (refIndex + 1) index as


visToFlag :: Visibility -> Int
visToFlag Public = 1
visToFlag Private = 2
-- visToFlag Protected = 4

typeToDescriptor :: Type -> String
typeToDescriptor "boolean" = "Z"
typeToDescriptor "char" = "C"
typeToDescriptor "int" = "I"
typeToDescriptor "void" = "V"
typeToDescriptor object = "L" ++ object ++ ";"

iconst :: Int -> Assembler
iconst 0 = Iconst0
iconst 1 = Iconst1
iconst 2 = Iconst2
iconst 3 = Iconst3
iconst 4 = Iconst4
iconst 5 = Iconst5
iconst n = Bipush n

-- | concatenates to lists in applicatives
(-++-) :: Applicative m => m [a] -> m [a] -> m [a]
a -++- b = (++) <$> a <*> b
