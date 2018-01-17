{-# LANGUAGE TemplateHaskell #-}

{-|
This module generates the code for all methods except the <init> method
of a class file
-}
module Codegen.GenerateMethods (
  genMethods
) where
import ABSTree
import qualified Codegen.Data.MethodFormat as MF
import Codegen.GenerateFields(genCode)
import Data.Char(ord)
import qualified Data.HashMap.Lazy as HM
import Codegen.Data.MethodFormat hiding (Return, New)
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
                   _localVar :: [HM.HashMap LocVarName LocVarIndex ]
                 , _classFile :: ClassFile
                 , _curStack :: Int
                 , _maxStack :: Int
                 , _line :: LineNumber
                 -- | Stack of lines to which break should jump
                 , _continueLine :: [LineNumber]
                 }
makeLenses ''Vars

genMethods :: [FieldDecl] -> [MethodDecl] -> State ClassFile ()
genMethods vds mds
  = modify (set countMethods (length mds)) >> mapM_ (genMethod vds) mds

genMethod :: [FieldDecl] -- ^ fields for initial code of constructor
          -> MethodDecl -> State ClassFile ()
genMethod fds (MethodDecl name typ argDecls stmt vis static) =
  do indexName <- genUTF8 name
     -- generate initial code for constructors
     let lengthInit = 0
         codeInit = []
         genInitCode = mapM genFD
         genFD (FieldDecl vds _ _) = mapM genCode vds
     when (typ == "") -- constructors have no type
       $ do (lengthInit,codeInit)
                <- (\p -> ((+5) .sum $ map fst p
                          , [Aload0, Invokespecial 0 1] ++ concatMap snd p))
                    . concat <$> genInitCode fds
            return ()
     -- generate descriptor
     let getArgDesr (ArgumentDecl _ typ _) = typeToDescriptor typ
         descr = "(" ++ concatMap getArgDesr argDecls ++ ")"
                     ++ typeToDescriptor typ
     indexType <- genUTF8 descr
     indexCode <- genUTF8 "Code"
     cf <- get
     -- generate code
     let (code,vars)
           = runState (codeToInt . (codeInit++) <$> genCodeStmt stmt)
                      Vars { _localVar = [HM.fromList $ ("This", 0)
                                          : zip
                                            (map
                                              (\(ArgumentDecl n _ _) -> n)
                                              argDecls) [1..]]
                           , _classFile = cf
                           , _curStack = 0
                           , _maxStack = 0
                           , _line = 0
                           , _continueLine = []
                           }
     put $ vars^.classFile
     let accessFlags = visToFlag vis : [8 | static]
         codeAttr = AttributeCode { _indexNameAttr = indexCode
                                  , _tamLenAttr = 16 + vars^.line + lengthInit
                                  , _lenStackAttr = vars^.maxStack
                                  , _lenLocalAttr = length $ vars^.localVar
                                  , _tamCodeAttr = vars^.line + lengthInit
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
  do modify $ over localVar (HM.fromList []:)
     code <- foldr ((-++-) . genCodeStmt) (return []) stmts
     modify $ over localVar tail
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

genCodeStmt (If cond bodyIf (Just bodyElse))
  = genIf genCodeStmt cond bodyIf bodyElse

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
genCodeStmt (StmtExprStmt stmtExpr) = genCodeStmtExpr stmtExpr
genCodeStmt (TypedStmt stmt _) = genCodeStmt stmt

genCodeExpr :: Expr -> State Vars Code
genCodeExpr This =  modify (over line (+1)) >> return [Aload0]

--Vars
genCodeExpr (TypedExpr (LocalOrFieldVar var) typ)=
  do locVar <- getLocIdx var . view localVar <$> get
     case locVar of
       (Just idx)
         -> do modify $ over line (+(if idx > 3 then 2 else 1))
               return $ case typ of
                          -- TODO check types
                          "objectref" -> [aload idx]
                          "double"    -> [dload idx]
                          "float"     -> [fload idx]
                          "long"      -> [lload idx]
                          _           -> [iload idx]
       _ -> do idx <- zoom classFile $ genFieldRefThis var typ
               modify $ over line (+1)
               let (b1,b2) = split16Byte idx
               return [Getstatic b1 b2]

genCodeExpr (TypedExpr (InstVar obj varName) typ) =
  do code <- genCodeExpr obj
     indexVar
       <- case obj of
            (LocalOrFieldVar cN) -> zoom classFile
                                         $ genFieldRef varName cN typ
            _                    -> zoom classFile
                                         $ genFieldRefThis varName typ
     modify $ over line (+3)
     let (b1,b2) = split16Byte indexVar
     return $ code ++ [Getfield b1 b2] -- variable of a object

genCodeExpr (TypedExpr (Unary op expr) typ)
  = genCodeExpr expr
    -++- (case (op,typ) of
            ("+",_)         -> return []
            ("-","double")  -> modify (over line (+1))
                               >> return [Dneg]
            ("-","float")   -> modify (over line (+1))
                               >> return [Fneg]
            ("-","long")    -> modify (over line (+1))
                               >> return [Lneg]
            ("-",_)         -> modify (over line (+1))
                               >> return [Ineg]
            ("++","double") -> modify (over line (+2))
                               >> modifyStack 1 -- could change max
                               >> modifyStack (-1)
                               >> return [Dconst1,Dadd]
            ("++","float")  -> modify (over line (+2))
                               >> modifyStack 1 -- could change max
                               >> modifyStack (-1)
                               >> return [Fconst1,Fadd]
            ("++","long")   -> modify (over line (+2))
                               >> modifyStack 1 -- could change max
                               >> modifyStack (-1)
                               >> return [Lconst1,Ladd]
            ("++",_)        -> modify (over line (+2))
                               >> modifyStack 1 -- could change max
                               >> modifyStack (-1)
                               >> return [Iconst1,Iadd]
            ("--","double") -> modify (over line (+2))
                               >> modifyStack 1 -- could change max
                               >> modifyStack (-1)
                               >> return [Dconst1,Dneg]
            ("--","float")  -> modify (over line (+2))
                               >> modifyStack 1 -- could change max
                               >> modifyStack (-1)
                               >> return [Fconst1,Fneg]
            ("--","long")   -> modify (over line (+2))
                               >> modifyStack 1 -- could change max
                               >> modifyStack (-1)
                               >> return [Lconst1,Lneg]
            ("--",_)        -> modify (over line (+2))
                               >> modifyStack 1 -- could change max
                               >> modifyStack (-1)
                               >> return [Iconst1,Ineg]
            ("!",_)         -> modify (over line (+3))
                               >> modifyStack 1 -- could change max
                               >> modifyStack (-1)
                               >> return [Ineg, Iconst1, Isub])

genCodeExpr (TypedExpr (Binary op expr1 expr2) typ)
  = genCodeExpr expr1
    -++- genCodeExpr expr2
    -++- (modify (over line (+1))
          >> modifyStack (-1)
          >> return (case (op,typ) of
                        ("+" ,"double") -> [Dadd]
                        ("+" ,"float")  -> [Fadd]
                        ("+" ,"long")   -> [Ladd]
                        ("+" ,_)        -> [Iadd]
                        ("-" ,"double") -> [Dsub]
                        ("-" ,"float")  -> [Fsub]
                        ("-" ,"long")   -> [Lsub]
                        ("-" ,_)        -> [Isub]
                        ("*" ,"double") -> [Dmul]
                        ("*" ,"float")  -> [Fmul]
                        ("*" ,"long")   -> [Lmul]
                        ("*" ,_)        -> [Imul]
                        ("&&",_)        -> [Iand]
                        ("||",_)        -> [Ior]))
genCodeExpr (InstanceOf expr typ) = undefined
    -- TODO extra instanceOf
-- expr1 ? expr2 : expr3
genCodeExpr (Ternary cond expr1 expr2)
  = genIf genCodeExpr cond expr1 expr2

genCodeExpr (BooleanLiteral True)
  = modify (over line (+1)) >> return [Iconst1]
genCodeExpr (BooleanLiteral False)
  = modify (over line (+1)) >> return [Iconst0]
genCodeExpr (CharLiteral char)
  = do modify (over line (+(if ord char> 5 then 2 else 1)))
       return [iconst $ ord char]
genCodeExpr (IntegerLiteral int)
  = do modify (over line (+(if int > 5 then 2 else 1)))
       return [iconst $ fromIntegral int]
    --  LongLiteral Int64
    --  FloatLiteral Float
    --  DoubleLiteral Double
    --  StringLiteral String
genCodeExpr JNull = do modify (over line (+1))
                       modifyStack 1
                       return [AconstNull]
genCodeExpr (StmtExprExpr sE) = genCodeStmtExpr sE
genCodeExpr (TypedExpr expr _) = genCodeExpr expr

genCodeVarDecl :: VariableDecl -> State Vars Code
genCodeVarDecl (VariableDecl name typ _ mayExpr) =
  do modify
       $ over localVar
          $ \(h:hs) -> (HM.insert
                         name (maximum . map snd $ HM.toList h) h
                         : hs)
     case mayExpr of
       (Just expr) -> genCodeStmtExpr
                        (Assign
                           (TypedExpr (LocalOrFieldVar name) typ) expr)
       _           -> return []

genCodeStmtExpr :: StmtExpr -> State Vars Code
genCodeStmtExpr (Assign (TypedExpr (LocalOrFieldVar var) typ) expr)
  = genCodeExpr expr
    -++- do exprCode <- genCodeExpr expr
            locVar <- getLocIdx var . view localVar <$> get
            modifyStack (-1)
            case locVar of
              -- local variable
              (Just idx)
                -> do modify $ over line (+(if idx > 3 then 2 else 1))
                      return $ case typ of
                                 -- TODO check types
                                 "objectref" -> [astore idx]
                                 "double"    -> [dstore idx]
                                 "float"     -> [fstore idx]
                                 "long"      -> [lstore idx]
                                 _           -> [istore idx]
              -- TODO static call in other class
              -- field variable
              _ -> do idx <- zoom classFile $ genFieldRefThis var typ
                      modify $ over line (+3)
                      let (b1,b2) = split16Byte idx
                      return [Putstatic b1 b2] -- TODO or putfield(object)

genCodeStmtExpr (TypedStmtExpr (Assign (TypedExpr (InstVar obj name)
                                                  typ) expr) className)
  = genCodeExpr obj
    -++- genCodeExpr expr
    -++- do idx <- zoom classFile $ genFieldRef className name typ
            modify $ over line (+3)
            modifyStack (-2)
            let (b1,b2) = split16Byte idx
            return [Putfield b1 b2]

genCodeStmtExpr (New typ args) =
  do obj <- zoom classFile $ genClass typ
     let (b1,b2) = split16Byte obj
     (MF.New b1 b2:) <$> genMethConst Nothing typ args

genCodeStmtExpr (MethodCall expr name args)
  = genMethConst (Just expr) name args
-- TODO whats the difference?
genCodeStmtExpr (LazyAssign var expr)
  = genCodeStmtExpr (Assign var expr)
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

-- gen If or cond?e1:e2
genIf gen cond bodyIf bodyElse =
  do condCode <- genCodeExpr cond
     ref <- (+1) . view line <$> get
     modify $ over line (+3) -- length of Ifeq
     bodyIfCode <- gen bodyIf
     endIf <- view line <$> get
     modify $ over line (+1)
     bodyElseCode <- gen bodyElse
     endElse <- view line <$> get
     let (b1,b2) = split16Byte . twoCompliment16 $ endIf + 4 - ref
         (b3,b4) = split16Byte . twoCompliment16  $ endElse - endIf
     return $ condCode ++ [Ifeq b1 b2] ++ bodyIfCode ++ [Goto b3 b4]
                       ++ bodyElseCode

-- generate a method or a constructor
genMethConst :: Maybe Expr -> String -> [Expr] -> State Vars Code
genMethConst = undefined

-- | put n items on the opstack.  Calculates new max stack depth
modifyStack :: Int -> State Vars ()
modifyStack n = do modify $ over curStack (+n)
                   cur <- view curStack <$> get
                   curMax <- view maxStack <$> get
                   modify $ set maxStack $ max cur curMax

getLocIdx :: LocVarName
          -> [HM.HashMap LocVarName LocVarIndex]
          -> Maybe LocVarIndex
getLocIdx _   []            = Nothing
getLocIdx var (vars:blocks) = case HM.lookup var vars of
                                idx@(Just _) -> idx
                                _            -> getLocIdx var blocks

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


-- | concatenates to lists in applicatives
(-++-) :: Applicative m => m [a] -> m [a] -> m [a]
a -++- b = (++) <$> a <*> b
