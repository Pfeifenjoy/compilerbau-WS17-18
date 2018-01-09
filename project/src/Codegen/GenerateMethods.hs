{-# LANGUAGE TemplateHaskell #-}

module Codegen.GenerateMethods (
  generateMethods
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

data Vars = Vars { _localVar :: HM.HashMap Int String
                 , _classFile :: ClassFile
                 , _deepness :: Int -- ^ deepness of nested block
                 , _line :: Int -- ^ line number
                 , _continueLine :: [Int] -- ^ Stack of line to which 
                                          --   break should jump
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
     let (code,vars) = runState (codeToInt <$> generateMethodsStmt stmt) 
                                 Vars { _localVar = HM.fromList [] 
                                      , _classFile = cf
                                      , _deepness = 0
                                      , _line = 0
                                      , _continueLine = [] 
                                      }
     put $ vars^.classFile 
     let accessFlags = visToFlag vis : [8 | static] 
         codeAttr = AttributeCode { _indexNameAttr = indexCode
                                  , _tamLenAttr = undefined
                                  , _lenStackAttr = undefined
                                  , _lenLocalAttr = undefined
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

generateMethodsStmt :: Stmt -> State Vars MF.Code
-- Block
generateMethodsStmt (Block stmts) =
  do modify $ over deepness (+1) 
     code <- foldr ((-++-) . generateMethodsStmt) (return []) stmts
     modify $ over deepness (\x -> x-1) 
     return code

-- Return 
generateMethodsStmt (Return expr) = undefined

-- While
generateMethodsStmt (While cond body) =
  do modify $ \vars -> over continueLine (vars^.line+1:) vars
     (condCode,bodyCode) <- getCondBodyCode cond body 
     breakLine <- view line <$> get
     let (b1,b2) = split16Byte breakLine 
         code = condCode ++ [Ifeq b1 b2] ++ adBreaks breakLine bodyCode
     modify $ over continueLine tail 
     return code

-- DoWhile
generateMethodsStmt (DoWhile cond body) = 
  do modify $ \vars -> over continueLine (vars^.line+1:) vars
     bodyCode <- generateMethodsStmt body
     condCode <- generateMethodsExpr cond
     modify (over line (+1)) 
     breakLine <- view line <$> get
     let (b1,b2) = split16Byte breakLine 
         code = adBreaks breakLine bodyCode ++ condCode ++ [Ifne b1 b2] 
     modify $ over continueLine tail 
     return code

-- For
generateMethodsStmt (For stmt1 expr stmt2 body) = 
  do modify $ \vars -> over continueLine (vars^.line+1:) vars
     condCode <- generateMethodsStmt stmt1
              -++- generateMethodsExpr expr
              -++- generateMethodsStmt stmt2
     modify (over line (+1)) 
     bodyCode <- generateMethodsStmt body
     breakLine <- view line <$> get
     let (b1,b2) = split16Byte breakLine 
         code = condCode ++ [Ifeq b1 b2] ++ adBreaks breakLine bodyCode 
     modify $ over continueLine tail 
     return code

generateMethodsStmt Break = undefined
generateMethodsStmt Continue = undefined
generateMethodsStmt (If cond body (Just elseBody)) = undefined
generateMethodsStmt (If cond body Nothing) = 
  do (condCode,bodyCode) <- getCondBodyCode cond body 
     endIf <- view line <$> get
     let (b1,b2) = split16Byte endIf 
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
    -++- (modify (over line (+1)) >> return [Iadd])
generateMethodsExpr (Binary "-" expr1 expr2) = undefined
-- TODO add Isub to assembler
--  = generateMethodsExpr expr1
--    -++- generateMethodsExpr expr2
--    -++- (modify (over line (+1)) >> return [Isub])
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

getCondBodyCode :: Expr -> Stmt -> State Vars (Code,Code)
getCondBodyCode cond body =
  do condCode <- generateMethodsExpr cond
     modify (over line (+1)) 
     bodyCode <- generateMethodsStmt body
     return (condCode,bodyCode)


split16Byte :: Int -- ^ 16 Byte
            -> (Int -- ^ upper 8 byte
               ,Int) -- ^ lower 8 byte
split16Byte i = (div n (2^8),mod n (2^8))
  where n = twoCompliment16 i


-- TODO make sure that's correct
twoCompliment16 :: Int -> Int
twoCompliment16 i = -(i .&. mask) + (i .&. complement mask)
  where mask = 2^(16-1)

adBreaks :: Int -> Code -> Code
adBreaks index [] = []
adBreaks index (Goto 0 0:as) = Goto b1 b2: adBreaks index as 
  where (b1,b2) = split16Byte index
adBreaks index (a:as) = a : adBreaks index as 

visToFlag :: Visibility -> Int
visToFlag Public = 1
visToFlag Private = 2
-- visToFlag Protected = 4

typeToDescriptor :: String -> String
typeToDescriptor "boolean" = "Z"
typeToDescriptor "char" = "C"
typeToDescriptor "int" = "I"
typeToDescriptor "void" = "V"
typeToDescriptor object = "L" ++ object ++ ";"

iconst :: Int -> Assembler
iconst 0 = Iconst0
iconst 1 = Iconst1
iconst 2 = Iconst2

(-++-) :: Applicative m => m [a] -> m [a] -> m [a]
a -++- b = (++) <$> a <*> b 
