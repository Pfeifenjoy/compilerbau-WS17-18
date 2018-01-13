{-# LANGUAGE TemplateHaskell #-}

{-|
This module generates the code for all methods except the <init> method
of a class file
-}
module Codegen.GenerateMethods (
  generateMethods,
  visToFlag,
  typeToDescriptor,
  iconst,
  split16Byte
) where
import ABSTree
import qualified Codegen.Data.MethodFormat as MF 
import qualified Data.HashMap.Lazy as HM
import Data.Bits
import Codegen.Data.MethodFormat hiding (Return)
import Codegen.Data.ClassFormat
import Codegen.GenerateConstantPool
import Control.Lens
import Control.Arrow
import Control.Monad
import Control.Monad.Trans.State.Lazy


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

generateMethods :: [MethodDecl] -> State ClassFile () 
generateMethods mds 
  = modify (set countMethods (length mds)) >> mapM_ generateMethod mds 

generateMethod ::  MethodDecl -> State ClassFile ()
generateMethod (MethodDecl name typ argDecls stmt vis static) = 
  do indexName <- generateUTF8 name 
     let getArgDesr (ArgumentDecl _ typ _) = typeToDescriptor typ
         descr = "(" ++ concatMap getArgDesr argDecls ++ ")"
                     ++ typeToDescriptor typ
     indexType <- generateUTF8 descr 
     indexCode <- generateUTF8 "Code" 
     cf <- get 
     let (code,vars) 
           = runState (codeToInt <$> generateMethodsStmt stmt) 
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

generateMethodsStmt :: Stmt -> State Vars Code
-- Block
generateMethodsStmt (Block stmts) =
  do modify $ over deepness (+1) 
     code <- foldr ((-++-) . generateMethodsStmt) (return []) stmts
     modify $ over deepness (\x -> x-1) 
     return code

-- Return 
generateMethodsStmt (TypedStmt (Return expr) typ) =
  do exprCode <- generateMethodsExpr expr
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
generateMethodsStmt (While cond body) =
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
generateMethodsStmt (DoWhile cond body) = 
  do refLine <- (+1) . view line <$> get 
     modify $ over continueLine (refLine:)
     bodyCode <- generateMethodsStmt body
     condCode <- generateMethodsExpr cond
     modify $ over line (+3) -- length of Ifne
     breakLine <- (+1) . view line <$> get
     let (b1,b2) = split16Byte . twoCompliment16  $ breakLine - refLine
         code = adBreaks refLine breakLine bodyCode ++ condCode 
                                                    ++ [Ifne b1 b2]
     modify $ over continueLine tail 
     return code

-- For
generateMethodsStmt (For init cond iter body) = 
  do initialCode <- generateMethodsStmt init -- i.e. i = 1
     (refLine,condCode,bodyCode) <- getForWhileCode cond body
     iterateCode <- generateMethodsStmt iter -- i.e. i++
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

generateMethodsStmt Break =
  do modify $ over line (+3) 
     return [Goto 0 0]
  
generateMethodsStmt Continue =
  do modify $ over line (+3) 
     refLine <- (+1) . view line <$> get
     conLine <- head . view continueLine <$> get     
     let (b1,b2) = split16Byte . twoCompliment16  $ conLine - refLine
     return [Goto b1 b2]

generateMethodsStmt (If cond bodyIf (Just bodyElse)) = 
  do condCode <- generateMethodsExpr cond 
     ref <- (+1) . view line <$> get
     modify $ over line (+3) -- length of Ifeq
     bodyIfCode <- generateMethodsStmt bodyIf 
     endIf <- view line <$> get
     modify $ over line (+1)
     bodyElseCode <- generateMethodsStmt bodyElse 
     endElse <- view line <$> get
     let (b1,b2) = split16Byte . twoCompliment16 $ endIf + 4 - ref
         (b3,b4) = split16Byte . twoCompliment16  $ endElse - endIf
     return $ condCode ++ [Ifeq b1 b2] ++ bodyIfCode ++ [Goto b3 b4]
                       ++ bodyElseCode 

generateMethodsStmt (If cond body Nothing) = 
  do ref <- (+1) . view line <$> get
     (condCode,bodyCode) <- getCondBodyCode cond body 
     endIf <- view line <$> get
     let (b1,b2) = split16Byte . twoCompliment16 $ endIf - ref
     return $ condCode ++ [Ifeq b1 b2] ++ bodyCode 

generateMethodsStmt (Switch expr switchCases (Just stmts)) = undefined
generateMethodsStmt (Switch expr switchCases Nothing) = undefined
generateMethodsStmt (LocalVarDecls variableDecls) = undefined
generateMethodsStmt (StmtExprStmt stmtExpr) = undefined
generateMethodsStmt (TypedStmt stmt _) = generateMethodsStmt stmt 

generateMethodsExpr :: Expr -> State Vars MF.Code
generateMethodsExpr This = undefined
generateMethodsExpr (LocalOrFieldVar str) = undefined
generateMethodsExpr (InstVar expr str) = undefined
generateMethodsExpr (Unary str expr) = undefined
generateMethodsExpr (Binary "+" expr1 expr2)
  = generateMethodsExpr expr1
    -++- generateMethodsExpr expr2
    -++- (modify (over line (+1)) >> modifyStack (-1) >> return [Iadd])
generateMethodsExpr (Binary "-" expr1 expr2) = undefined
-- TODO add Isub to assembler
--  = generateMethodsExpr expr1
--    -++- generateMethodsExpr expr2
--    -++- (modify (over line (+1)) >> modiyStack (-1) >> return [Isub])
generateMethodsExpr (InstanceOf expr typ) = undefined
    -- TODO extra instanceOf
-- expr1 ? expr2 : expr3 cf = undefined
generateMethodsExpr (Ternary expr1 expr2 expr3) = undefined
generateMethodsExpr (BooleanLiteral True)
  = modify (over line (+1)) >> return [Iconst1]
generateMethodsExpr (BooleanLiteral False)
  = modify (over line (+1)) >> return [Iconst0] 
generateMethodsExpr (CharLiteral char) = undefined
generateMethodsExpr (IntegerLiteral int) 
  = modify (over line (+1)) >> return [iconst $ fromIntegral int]
    --  LongLiteral Int64
    --  FloatLiteral Float
    --  DoubleLiteral Double
    --  StringLiteral String
generateMethodsExpr JNull = undefined
generateMethodsExpr (StmtExprExpr stmtExpr) = undefined
generateMethodsExpr (TypedExpr expr _) = generateMethodsExpr expr


-- helper functions

getForWhileCode :: Expr -> Stmt -> State Vars (LineNumber,Code,Code) 

getForWhileCode cond body =
  do refLine <- (+1) . view line <$> get
     modify $ over continueLine (refLine:)
     (condCode,bodyCode) <- getCondBodyCode cond body
     return (refLine,condCode,bodyCode)

getCondBodyCode :: Expr -> Stmt -> State Vars (Code,Code)
getCondBodyCode cond body =
  do condCode <- generateMethodsExpr cond
     modify (over line (+3)) -- jump + 2 branch bytes
     bodyCode <- generateMethodsStmt body
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
