module Codegen.GenerateFields (
  generateFields
) where

import ABSTree
import Codegen.Data.ClassFormat
import Codegen.GenerateConstantPool
import Data.Char(ord)
import Control.Lens

generateFields :: ClassFile ->  [FieldDecl] -> ClassFile
generateFields = foldl generateFD

generateFD :: ClassFile -> FieldDecl -> ClassFile
generateFD cf (FieldDecl vds vis static) 
  = foldl (generateVD vis static) cf vds

generateVD :: Visibility 
           -> Bool 
           -> ClassFile 
           -> VariableDecl 
           -> ClassFile
generateVD vis static cf (VariableDecl name typ final mayExpr)
  = countFields +~ 1 $ over arrayFields (fieldInfo:) newCF
    where
      fieldInfo = FieldInfo { _afFi = AccessFlags accessFlags
                            , _indexNameFi = indexName
                            , _indexDescrFi = indexType
                            , _tamFi = length attrFields
                            , _arrayAttrFi = attrFields 
                            }
      accessFlags = visToFlag vis : [8 | static] ++ [4 | final]
      (newCF'',indexName) = generateUTF8 cf name 
      (newCF',indexType) = generateUTF8 newCF'' (typeToDescriptor typ) 
      (attrFields,newCF) = generateAttrFields newCF' mayExpr 

generateAttrFields :: ClassFile -> Maybe Expr -> (AttributeInfos,ClassFile)
generateAttrFields cf Nothing  = ([],cf)
generateAttrFields cf (Just expr) = ([constant],newCF)
  where
    constant = AttributeConstantValue { _indexNameAttr = index
                                      , _tamAttr = 2
                                      , _indexValueAttr = value
                                      }
    (newCF',index) = generateUTF8 cf "constant"
    (newCF,value) = exprToConstantPool newCF' expr 

-- helper functions

exprToConstantPool :: ClassFile -> Expr -> (ClassFile,Int)
exprToConstantPool cf (BooleanLiteral True) = generateInteger cf 1
exprToConstantPool cf (BooleanLiteral False) = generateInteger cf 1
exprToConstantPool cf (CharLiteral char) = generateInteger cf $ ord char 
exprToConstantPool cf (IntegerLiteral int) = generateInteger cf $ fromIntegral int 

visToFlag :: Visibility -> Int
visToFlag Public = 1
visToFlag Private = 2
-- visToFlag Protected = 4

typeToDescriptor :: String -> String
typeToDescriptor "boolean" = "Z"
typeToDescriptor "char" = "C"
typeToDescriptor "int" = "I"
