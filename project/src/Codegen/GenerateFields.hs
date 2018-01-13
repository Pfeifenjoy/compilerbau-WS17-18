{-| 
This module generates the fields. Additional it generates the init 
method, which is used to assign non final values to the fields.
-} 
module Codegen.GenerateFields (
  generateFields
) where

import ABSTree hiding (Return)
import Codegen.Data.ClassFormat
import Codegen.Data.MethodFormat
import Codegen.GenerateConstantPool
import Data.Char(ord)
import Data.Bits
import Control.Lens
import Control.Monad.Trans.State.Lazy
import Codegen.GenerateMethods(visToFlag,typeToDescriptor,iconst,split16Byte)

generateFields :: [FieldDecl] -> State ClassFile ()
generateFields = mapM_ generateFD

generateFD ::  FieldDecl -> State ClassFile ()
generateFD (FieldDecl vds vis static) 
  = mapM_ (generateVD vis static) vds >> generateInit vds

generateVD :: Visibility 
           -> Bool -- ^ is the field static? 
           -> VariableDecl 
           -> State ClassFile ()
generateVD vis static (VariableDecl name typ final mayExpr) = 
  do indexName <- generateUTF8 name 
     indexType <- generateUTF8 $ typeToDescriptor typ 
     attrFields <- generateAttrFields mayExpr 
     let accessFlags = visToFlag vis : [0x8 | static] ++ [0x10 | final]
         fieldInfo = FieldInfo { _afFi = AccessFlags accessFlags
                               , _indexNameFi = indexName
                               , _indexDescrFi = indexType
                               , _tamFi = length attrFields
                               , _arrayAttrFi = attrFields 
                               } 
     modify $ (countFields +~ 1) . over arrayFields (fieldInfo:)
           

generateAttrFields :: Maybe Expr 
                   -> State ClassFile AttributeInfos
generateAttrFields Nothing  = return [] 
generateAttrFields (Just expr) = 
  do indexName <- generateUTF8 "constant"
     indexValue <- exprToConstantPool expr 
     return [AttributeConstantValue { _indexNameAttr = indexName
                                    , _tamAttr = 2
                                    , _indexValueAttr = indexValue
                                    }]

generateInit :: [VariableDecl] -> State ClassFile ()
generateInit vds = 
  do indexType <- generateUTF8 "()V" 
     indexCode <- generateUTF8 "Code" 
     indexName <- (view $ this . indexTh) <$> get
     codeVars <- mapM generateCode vds 
     let code = codeToInt $ [Aload0,Invokespecial 0 1] 
                            ++ concatMap snd codeVars
                            ++ [Return]
         lengthCode = 5 + sum (map fst codeVars)
         codeAttr = AttributeCode { _indexNameAttr = indexCode
                                  , _tamLenAttr = 14+lengthCode
                                  , _lenStackAttr = 1 
                                  , _lenLocalAttr = 1 
                                  , _tamCodeAttr = lengthCode
                                  , _arrayCodeAttr = code 
                                  , _tamExAttr = 0 
                                  , _arrayExAttr = [] 
                                  , _tamAtrrAttr = 0 
                                  , _arrayAttrAttr = [] 
                                  }
         methodInfo = MethodInfo { _afMi = AccessFlags [] 
                                 , _indexNameMi = indexName 
                                 , _indexDescrMi = indexType 
                                 , _tamMi = 1 
                                 , _arrayAttrMi = [codeAttr] 
                                 }
     modify $ over arrayMethods (methodInfo:) 

generateCode :: VariableDecl -> State ClassFile (Int,Code)
generateCode (VariableDecl _ _  _ Nothing) = return (0,[])
generateCode (VariableDecl name "float" _ (Just expr)) = undefined
generateCode (VariableDecl name _  _ (Just expr)) =
  do indexName <- generateUTF8 name 
     let val = evalInt expr 
         (b1,b2) = split16Byte indexName
     return (if val > 5 then 6 else 5
            ,[Aload0,iconst val,Putfield b1 b2])
-- helper functions

evalInt ::  Expr -> Int 
evalInt (BooleanLiteral True)  = 1
evalInt (BooleanLiteral False) = 0
evalInt (CharLiteral char)     = ord char 
evalInt (IntegerLiteral int)   = fromIntegral int 
evalInt (Binary "&&" expr1 expr2) = evalInt expr1 .&. evalInt expr2
evalInt (Binary "||" expr1 expr2) = evalInt expr1 .|. evalInt expr2
evalInt (Binary "+" expr1 expr2) = evalInt expr1 + evalInt expr2
evalInt (Binary "-" expr1 expr2) = evalInt expr1 - evalInt expr2
evalInt (Binary "*" expr1 expr2) = evalInt expr1 * evalInt expr2

exprToConstantPool ::  Expr -> State ClassFile Int
exprToConstantPool = generateInteger . evalInt 
