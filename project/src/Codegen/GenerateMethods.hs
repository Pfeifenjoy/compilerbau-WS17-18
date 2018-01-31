{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS -Wall #-}

{-|
This module generates the code for all methods except the <init> method
of a class file
-}
module Codegen.GenerateMethods (
  genMethods
) where
import ABSTree
import qualified Codegen.Data.Assembler as A
import Codegen.GenerateFields(genCode)
import Codegen.EvalCode
import Data.Char(ord)
import qualified Data.HashMap.Lazy as HM
import Codegen.Data.Assembler hiding (Return, New)
import Codegen.Data.ClassFormat
import Codegen.GenerateConstantPool
import Control.Lens hiding (op)
import Control.Monad.Trans.State.Lazy
import qualified Data.Set as S

-- | The name of a local variable.  It is the name in the source code
--   followed by the deepness in a nested block
type LocVarName = String

-- | The index of a local variable in the heap
type LocVarIndex = Int

-- | The line number in the assembler code
type LineNumber = Int

data Vars = Vars { -- | maps the index of a local Variable to its name.
                   _localVar :: [HM.HashMap LocVarName LocVarIndex ]
                 , _allLocalVar :: S.Set String
                 , _classFile :: ClassFile
                 , _curStack :: Int
                 , _maxStack :: Int
                 , _line :: LineNumber
                 -- | Stack of lines to which break should jump
                 , _continueLine :: [LineNumber]
                 }
makeLenses ''Vars

genMethods :: [FieldDecl] -> [MethodDecl] -> State ClassFile ()
genMethods vds = mapM_ (genMethod vds)

genMethod :: [FieldDecl] -- ^ fields for initial code of constructor
          -> MethodDecl -> State ClassFile ()
genMethod fds (MethodDecl name typ argDecls stmt vis static) =
  do indexName <- genUTF8 name
     -- generate initial code for constructors
     let genInitCode = mapM genFD
         genFD (FieldDecl vds _ _) = mapM genCode vds
     (lengthInit,codeInit)
       <- if typ == "" -- constructors have no type
          then (\p -> ((+5) .sum $ map fst p
                          , [Aload0, Invokespecial 0 1] ++ concatMap snd p))
                    . concat <$> genInitCode fds
          else return (0,[])
     -- generate descriptor
     let getArgDesr (ArgumentDecl _ argTyp _) = typeToDescriptor argTyp
         descr = "(" ++ concatMap getArgDesr argDecls ++ ")"
                     ++ typeToDescriptor typ
     indexType <- genUTF8 descr
     indexCode <- genUTF8 "Code"
     cf <- get
     -- generate code
     let (code,vars)
           = runState ((codeInit++) <$> genCodeStmt stmt)
                      Vars { _localVar = [HM.fromList $ ("This", 0)
                                          : zip
                                            (map
                                              (\(ArgumentDecl n _ _) -> n)
                                              argDecls) [1..]]
                           , _allLocalVar
                                = S.fromList $
                                   "This"
                                   : map (\(ArgumentDecl n _ _) -> n)
                                         argDecls
                           , _classFile = cf
                           , _curStack = case () of
                                          _ | lengthInit > 5 -> 2
                                          _ | lengthInit > 0 -> 1
                                          _ ->  0
                           , _maxStack = 0
                           , _line = lengthInit
                           , _continueLine = []
                           }
     put $ vars^.classFile
     let addReturn = typ == "void" && last code /= A.Return
         accessFlags = visToFlag vis : [8 | static]
         codeAttr = AttributeCode { _indexNameAttr = indexCode
                                  , _tamLenAttr
                                       = 12 + vars^.line + if addReturn
                                                           then 1 else 0
                                  , _lenStackAttr = vars^.maxStack
                                  , _lenLocalAttr
                                       = S.size $ vars^.allLocalVar
                                  , _tamCodeAttr
                                       = vars^.line + if addReturn
                                                      then 1 else 0
                                  , _arrayCodeAttr
                                       = code ++ [A.Return | addReturn]
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
genCodeStmt (Return _) = error "untyped return"
genCodeStmt (TypedStmt (Return expr) typ) =
  do exprCode <- genCodeExpr expr
     modify $ over line (+1) -- length of Ireturn
     return $ exprCode ++ (case typ of
                             "double"  -> [Dreturn]
                             "float"   -> [Freturn]
                             "byte"    -> [Ireturn]
                             "short"   -> [Ireturn]
                             "int"     -> [Ireturn]
                             "boolean" -> [Ireturn]
                             "char"    -> [Ireturn]
                             "long"    -> [Lreturn]
                             "void"    -> [A.Return]
                             _         -> [Areturn])

-- While
genCodeStmt (While cond body) =
  do (refLine,condCode,bodyCode) <- getForWhileCode cond body
     modify $ over line (+3) -- length of Goto
     breakLine <- (+1) . view line <$> get
     let (b1,b2) = split16Byte $ breakLine - refLine
         (b3,b4) = split16Byte $ refLine - breakLine - 1
         code = condCode b1 b2 ++ adBreaks refLine breakLine bodyCode
                               ++ [Goto b3 b4]
     modify $ over continueLine tail
     return code

-- DoWhile
genCodeStmt (DoWhile cond body) =
  do refLine <- (+1) . view line <$> get
     modify $ over continueLine (refLine:)
     bodyCode <- genCodeStmt body
     condCode <- genCond cond
     branchLine <- (+1) . view line <$> get
     modify $ over line (+3) -- length of Ifne
     breakLine <- (+1) . view line <$> get
     let (b1,b2) = split16Byte $ refLine - branchLine
         code = adBreaks refLine breakLine bodyCode ++ condCode b1 b2
     modify $ over continueLine tail
     return code

-- For
genCodeStmt (For initStmt cond iter body) =
  do initialCode <- genCodeStmt initStmt -- i.e. i = 1
     (refLine,condCode,bodyCode) <- getForWhileCode cond body
     iterateCode <- genCodeStmt iter -- i.e. i++
     modify (over line (+3)) -- Goto b1 b2
     breakLine <- view line <$> get
     let (b1,b2) = split16Byte $ breakLine - refLine
         (b3,b4) = split16Byte $ refLine - breakLine - 1
         code = initialCode ++ condCode b1 b2
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
     let (b1,b2) = split16Byte $ conLine - refLine
     return [Goto b1 b2]

genCodeStmt (If cond bodyIf (Just bodyElse))
  = genIf genCodeStmt cond bodyIf bodyElse

genCodeStmt (If cond body Nothing) =
  do ref <- (+1) . view line <$> get
     (condCode,bodyCode) <- getCondBodyCode cond body
     endIf <- view line <$> get
     let (b1,b2) = split16Byte $ endIf - ref
     return $ condCode b1 b2 ++ bodyCode

genCodeStmt (Switch expr switchCases defCase) =
  do exprCode <- genCodeExpr expr -- code to compare
     ref <- view line <$> get
     let pad = mod (ref+1) 4
         len = pad + 8 + 2 * length switchCases
     modify $ over line (+len) -- length of tableswitch assembler
     caseCodes <- mapM genCodeSwitchCase switchCases -- code of cases
     def <- (+1) . view line <$> get
     -- TODO add goto address to end of switch case
     defCode <- case defCase of
                  Nothing -> return []
                  (Just stmts) -> genCodeStmt $ Block stmts
     modifyStack (-1)
     let (d1,d2,d3,d4) = split32Byte def
         (n1,n2,n3,n4) = split32Byte $ length switchCases
     return $ exprCode
               ++ [Lookupswitch (replicate pad 0)
                   d1 d2 d3 d4 n1 n2 n3 n4
                   (map (\(x,y,_)
                      -> let (b1,b2,b3,b4) = split32Byte x
                             (b5,b6,b7,b8) = split32Byte y
                         in (b1,b2,b3,b4,b5,b6,b7,b8))
                    caseCodes)]
               ++ concatMap (\(_,_,x) -> x) caseCodes
               ++ defCode

genCodeStmt (LocalVarDecls vds)
  = foldr ((-++-) . genCodeVarDecl) (return []) vds
genCodeStmt (StmtExprStmt stmtExpr) = genCodeStmtExpr stmtExpr
genCodeStmt (TypedStmt stmt _) = genCodeStmt stmt

genCodeExpr :: Expr -> State Vars Code
genCodeExpr This =  modify (over line (+1)) >> return [Aload0]

--Vars
genCodeExpr (LocalOrFieldVar _) = error "untyped variable"
genCodeExpr (TypedExpr (LocalOrFieldVar var) typ)=
  do locVar <- getLocIdx var . view localVar <$> get
     case locVar of
       (Just idx)
         -> do modify $ over line (+(if idx > 3 then 2 else 1))
               modifyStack 1
               return $ case typ of
                          "double"    -> [dload idx]
                          "float"     -> [fload idx]
                          "long"      -> [lload idx]
                          "byte"      -> [iload idx]
                          "short"     -> [iload idx]
                          "int"       -> [iload idx]
                          "boolean"   -> [iload idx]
                          "char"      -> [iload idx]
                          _           -> [aload idx]
       _ -> do idx <- zoom classFile $ genFieldRefThis var typ
               modify $ over line (+1)
               let (b1,b2) = split16Byte idx
               return [Getstatic b1 b2]

genCodeExpr (InstVar _ _) = error "untyped instance variable"
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

genCodeExpr (Unary _ _) = error "untyped unary operation"
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
                               >> return [Dconst1,Dsub]
            ("--","float")  -> modify (over line (+2))
                               >> modifyStack 1 -- could change max
                               >> modifyStack (-1)
                               >> return [Fconst1,Fsub]
            ("--","long")   -> modify (over line (+2))
                               >> modifyStack 1 -- could change max
                               >> modifyStack (-1)
                               >> return [Lconst1,Lsub]
            ("--",_)        -> modify (over line (+2))
                               >> modifyStack 1 -- could change max
                               >> modifyStack (-1)
                               >> return [Iconst1,Isub]
            ("!",_)         -> modify (over line (+3))
                               >> modifyStack 1 -- could change max
                               >> modifyStack (-1)
                               >> return [Ineg, Iconst1, Isub]
            (_,_)           -> error "dont know operation")

genCodeExpr Binary{} = error "untyped binary"
genCodeExpr (TypedExpr (Binary op expr1 expr2) typ)
  = genCodeExpr expr1
    -++- genCodeExpr expr2
    -++- (modify (over line (+1))
          >> modifyStack (-1)
          >> (case (op,typ) of
                 ("+" ,"double") -> return [Dadd]
                 ("+" ,"float")  -> return [Fadd]
                 ("+" ,"long")   -> return [Ladd]
                 ("+" ,_)        -> return [Iadd]
                 ("-" ,"double") -> return [Dsub]
                 ("-" ,"float")  -> return [Fsub]
                 ("-" ,"long")   -> return [Lsub]
                 ("-" ,_)        -> return [Isub]
                 ("*" ,"double") -> return [Dmul]
                 ("*" ,"float")  -> return [Fmul]
                 ("*" ,"long")   -> return [Lmul]
                 ("*" ,_)        -> return [Imul]
                 ("^" ,_)        -> return [Ixor]
                 ("<<" ,_)       -> return [Ishl]
                 (">>" ,_)       -> return [Ishr]
                 (">>>" ,_)      -> return [Iushr]
                 ("&",_)         -> return [Iand]
                 -- TODO 2 complement
                 ("==",_)        -> modify (over line (+8))
                                    >> return [IfIcmpne 0 3, Iconst1
                                              , Goto 0 3, Iconst0]
                 ("!=",_)        -> modify (over line (+8))
                                    >> return [IfIcmpeq 0 3, Iconst1
                                              , Goto 0 3, Iconst0]
                 ("<" ,_)        -> modify (over line (+8))
                                    >> return [IfIcmpge 0 3, Iconst1
                                              , Goto 0 3, Iconst0]
                 (">=",_)        -> modify (over line (+8))
                                    >> return [IfIcmplt 0 3, Iconst1
                                              , Goto 0 3, Iconst0]
                 (">" ,_)        -> modify (over line (+8))
                                    >> return [IfIcmple 0 3, Iconst1
                                              , Goto 0 3, Iconst0]
                 ("<=",_)        -> modify (over line (+8))
                                    >> return [IfIcmpgt 0 3, Iconst1
                                              , Goto 0 3, Iconst0]
                 ("&&",_)        -> return [Iand]
                 ("|",_)         -> return [Ior]
                 ("||",_)        -> return [Ior]
                 (_,_)           -> error "dont know operation"))

genCodeExpr (InstanceOf expr typ) =
  do code <- genCodeExpr expr
     modify $ over line (+3)
     idx <- zoom classFile $ genClass typ
     let (b1,b2) = split16Byte idx
     return $ code ++ [Instanceof b1 b2]

-- expr1 ? expr2 : expr3
genCodeExpr (Ternary cond expr1 expr2)
  = genIf genCodeExpr cond expr1 expr2

genCodeExpr (BooleanLiteral True)
  = do modify (over line (+1))
       modifyStack 1
       return [Iconst1]
genCodeExpr (BooleanLiteral False)
  = do modify (over line (+1))
       modifyStack 1
       return [Iconst0]
genCodeExpr (CharLiteral char)
  = do modify (over line (+(if ord char> 5 then 2 else 1)))
       modifyStack 1
       return [iconst $ ord char]
genCodeExpr (IntegerLiteral int)
  = do modify (over line (+(if int > 5 then 2 else 1)))
       modifyStack 1
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
          $ \(h:hs)
              -> case HM.lookup name h of
                  (Just _) -> h:hs -- override variable
                  _       -- add new variable with new max index
                    -> HM.insert
                         name
                         (maximum (map (HM.foldr max 0) (h:hs))+1)
                         h : hs
     -- remember all variable to get the number
     modify $ over allLocalVar $ S.insert name
     case mayExpr of
       (Just expr) -> genCodeStmtExpr
                        (Assign
                          (TypedExpr (LocalOrFieldVar name) typ) expr)
       _           -> return []

genCodeStmtExpr :: StmtExpr -> State Vars Code
genCodeStmtExpr (Assign (LocalOrFieldVar _) _)
  = error "untyped local or field var"
genCodeStmtExpr (Assign (TypedExpr (LocalOrFieldVar var) typ) expr)
  = do exprCode <- genCodeExpr expr
       locVar <- getLocIdx var . view localVar <$> get
       modifyStack (-1)
       case locVar of
         -- local variable
         (Just idx)
           -> do modify $ over line (+(if idx > 3 then 2 else 1))
                 return $ exprCode ++ case typ of
                            "double"  -> [dstore idx]
                            "float"   -> [fstore idx]
                            "long"    -> [lstore idx]
                            "byte"    -> [istore idx]
                            "short"   -> [istore idx]
                            "int"     -> [istore idx]
                            "boolean" -> [istore idx]
                            "char"    -> [istore idx]
                            _         -> [astore idx]
         -- TODO static call in other class
         -- field variable
         _ -> do idx <- zoom classFile $ genFieldRefThis var typ
                 modify $ over line (+3)
                 let (b1,b2) = split16Byte idx
                 return $ exprCode ++ [Putfield b1 b2] -- TODO or putstatic

genCodeStmtExpr (Assign (InstVar _ _) _)
  = error "untyped instance var"
genCodeStmtExpr (TypedStmtExpr (Assign (TypedExpr (InstVar obj name)
                                                  typ) expr) className)
  = genCodeExpr obj
    -++- genCodeExpr expr
    -++- do idx <- zoom classFile $ genFieldRef className name typ
            modify $ over line (+3)
            modifyStack (-2)
            let (b1,b2) = split16Byte idx
            return [Putfield b1 b2]
genCodeStmtExpr (Assign (Unary _ _) _)
  = error "cant assign to unary"
genCodeStmtExpr (Assign This _)
  = error "cant assign to This"
genCodeStmtExpr (Assign Binary{} _)
  = error "cant assign to binary"
genCodeStmtExpr (Assign (InstanceOf _ _) _)
  = error "cant assign to instanceOf"
genCodeStmtExpr (Assign Ternary{} _)
  = error "cant assign to ternary"
genCodeStmtExpr (Assign _  _) = error "cant assign this!!" -- TODO
genCodeStmtExpr (New typ args) =
  do obj <- zoom classFile $ genClass typ
     let (b1,b2) = split16Byte obj
     modify $ over line (+4)
     modifyStack 2
     ([A.New b1 b2,Dup]++) <$> genMethConst "void" typ "<init>" args

genCodeStmtExpr (TypedStmtExpr (MethodCall (TypedExpr _ cl) n args) typ)
  = genMethConst typ cl n args

-- TODO whats the difference?
genCodeStmtExpr (LazyAssign var expr)
  = genCodeStmtExpr (Assign var expr)
genCodeStmtExpr (TypedStmtExpr se _) = genCodeStmtExpr se

genCodeStmtExpr _ = error "cant compile this!!" -- TODO

genCodeSwitchCase :: SwitchCase -> State Vars (LineNumber,Int,Code)
genCodeSwitchCase (SwitchCase expr cas) =
  do lin <- view line <$> get
     code <- genCodeStmt (Block cas)
     modify $ over line (+3) -- length of goto
     -- goto offset will be added later
     return (lin,evalInt expr,code++[Goto 0 0])

-- helper functions

getForWhileCode :: Expr -> Stmt -> State Vars (LineNumber,Byte -> Byte -> Code,Code)
getForWhileCode cond body =
  do refLine <- (+1) . view line <$> get
     modify $ over continueLine (refLine:)
     (condCode,bodyCode) <- getCondBodyCode cond body
     return (refLine,condCode,bodyCode)

getCondBodyCode :: Expr -> Stmt -> State Vars (Byte -> Byte -> Code,Code)
getCondBodyCode cond body =
  do condCode <- genCond cond
     modify (over line (+3)) -- jump + 2 branch bytes
     bodyCode <- genCodeStmt body
     return (condCode,bodyCode)

-- gen If or cond?e1:e2
genIf :: (t  -> State Vars Code) -> Expr -> t -> t -> State Vars Code
genIf gen cond bodyIf bodyElse =
  do condCode <- genCond cond
     ref <- (+1) . view line <$> get
     modify $ over line (+3) -- length of Ifeq
     bodyIfCode <- gen bodyIf
     endIf <- view line <$> get
     modify $ over line (+1)
     bodyElseCode <- gen bodyElse
     endElse <- view line <$> get
     let (b1,b2) = split16Byte $ endIf + 4 - ref
         (b3,b4) = split16Byte $ endElse - endIf
     return $ condCode b1 b2 ++ bodyIfCode ++ [Goto b3 b4]
                       ++ bodyElseCode

genCond :: Expr -> State Vars (Byte -> Byte -> Code)
genCond (TypedExpr (Binary ">" _ _) "") = undefined -- TODO other types
genCond (TypedExpr (Binary op e1 e2) _) =
  do c1 <- genCodeExpr e1
     c2 <- genCodeExpr e2
     return $ \b1 b2 -> c1 ++ c2 ++ case op of
                                     "==" -> [IfIcmpeq b1 b2]
                                     "!=" -> [IfIcmpne b1 b2]
                                     "<"  -> [IfIcmplt b1 b2]
                                     ">=" -> [IfIcmpge b1 b2]
                                     ">"  -> [IfIcmpgt b1 b2]
                                     "<=" -> [IfIcmple b1 b2]
                                     _    -> error $ "unknown operation" ++ op
genCond (TypedExpr expr _) = do c <- genCodeExpr expr
                                return $ \b1 b2 -> c ++ [Ifeq b1 b2]
genCond _ = error "untyped expression"

-- generate a method or a constructor
genMethConst :: Type -- ^ return type
             -> String -- ^ class name
             -> String -- ^ method name
             -> [Expr] -- ^ arguments for method
             -> State Vars Code
genMethConst typ' cl name args =
  do let typ = "(" ++ concatMap (typeToDescriptor . \(TypedExpr _ t) -> t) args
                   ++ ";)" ++ typ'
     idx <- zoom classFile $ genMethodRef name cl typ
     let (b1,b2) = split16Byte idx
     -- remove args and methodref from operand stack
     modifyStack (-(length args + 1))
     modify $ over line (+3) -- length of Invokespecial
     return $ case name of
                "<init>" -> [Invokespecial b1 b2]
                _        -> [Invokevirtual b1 b2]

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
adBreaks _ _ [] = []
adBreaks refIndex idx (Goto 0 0:as)
  = Goto b1 b2: adBreaks (refIndex + 1) idx as
      where (b1,b2) = split16Byte $ idx - refIndex
adBreaks refIndex idx (a:as) = a : adBreaks (refIndex + 1) idx as


-- | concatenates to lists in applicatives
(-++-) :: Applicative m => m [a] -> m [a] -> m [a]
a -++- b = (++) <$> a <*> b
