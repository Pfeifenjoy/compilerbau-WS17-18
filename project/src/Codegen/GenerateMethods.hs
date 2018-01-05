module Codegen.GenerateMethods (
  generateMethods
) where
import ABSTree
import qualified Codegen.Data.MethodFormat as MF 
import Codegen.Data.ClassFormat
import Codegen.GenerateConstantPool
import Control.Lens

generateMethods :: [MethodDecl] -> ClassFile -> ClassFile 
generateMethods mds cf 
  = foldl generateMethod (set countMethods (length mds) cf) mds 

generateMethod :: ClassFile -> MethodDecl -> ClassFile 
generateMethod cf (MethodDecl name typ argDecls stmt vis static)
  = over arrayMethods (methodInfo:) newCF 
    where
      methodInfo = MethodInfo { _afMi = AccessFlags accessFlags 
                              , _indexNameMi = indexName 
                              , _indexDescrMi = indexType 
                              , _tamMi = 1 
                              , _arrayAttrMi = [codeAttr] 
                              }
      accessFlags = visToFlag vis : [8 | static] 
      descr = "(" ++ concatMap getArgDesr argDecls ++ ")"
                  ++ typeToDescriptor typ
      codeAttr = AttributeCode { _indexNameAttr = indexCode
                           , _tamLenAttr = undefined
                           , _lenStackAttr = undefined
                           , _lenLocalAttr = undefined
                           , _tamCodeAttr = undefined
                           , _arrayCodeAttr = undefined
                           , _tamExAttr = 0 
                           , _arrayExAttr = [] 
                           , _tamAtrrAttr = 0 
                           , _arrayAttrAttr = [] 
                           }
      code = MF.codeToInt $ generateMethodsStmt stmt
      getArgDesr (ArgumentDecl _ typ _) = typeToDescriptor typ 
      (newCF'',indexName) = generateUTF8 cf name 
      (newCF',indexType) = generateUTF8 newCF'' descr 
      (newCF,indexCode) = generateUTF8 newCF' "Code" 

generateMethodsStmt :: Stmt -> MF.Code
generateMethodsStmt (Block stmts) = concatMap generateMethodsStmt stmts
generateMethodsStmt (Return expr) = undefined
generateMethodsStmt (While cond stmt) = undefined
generateMethodsStmt (DoWhile cond stmt) = undefined
generateMethodsStmt (For stmt1 expr stmt2 stmt3) = undefined
generateMethodsStmt Break = undefined
generateMethodsStmt Continue = undefined
generateMethodsStmt (If cond stmt (Just elseStmt)) = undefined
generateMethodsStmt (If cond stmt Nothing) = undefined
generateMethodsStmt (Switch expr switchCases (Just stmts)) = undefined
generateMethodsStmt (Switch expr switchCases Nothing) = undefined
generateMethodsStmt (LocalVarDecls variableDecls) = undefined
generateMethodsStmt (StmtExprStmt stmtExpr) = undefined
generateMethodsStmt (TypedStmt stmt _) = generateMethodsStmt stmt 

generateMethodsExpr :: Expr -> MF.Code
generateMethodsExpr = undefined

-- helper functions

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
