module Codegen.GenerateConstantPool where 
import Codegen.Data.ClassFormat
import ABSTree
import Control.Lens
import Prelude hiding ((!))
import qualified Data.HashMap.Lazy as HM
import Data.HashMap.Lazy ((!))

{-
 
Use this module to insert a constant in the constant pool

-}

-- | insert a class in the constant pool
generateClass :: ClassFile -- ^ Class with current constant pool
              -> String -- ^ class to insert in constant pool
              -> (ClassFile -- ^ new constant pool
                 ,Int) -- ^ location of field in constant pool
generateClass cl name = (countrCp +~ n $ newCl, loc)
    where
      loc = (newCl^.arrayCp) ! classInfo
      n = if loc > newCl^.countrCp then 1 else 0
      classInfo = ClassInfo { _tagCp   = TagClass
                            , _indexCp = index
                            , _desc    = ""
                            } 
      newCl = over arrayCp (HM.insert classInfo (cl'^.countrCp+1)) cl'
      (cl',index) = generateUTF8 cl name


-- | insert a field variable in the constant pool
generateFieldRef :: ClassFile -- ^ Class with current constant pool
                 -> Expr -- ^ field to insert in constant pool
                 -> (ClassFile -- ^ new constant pool
                    ,Int) -- ^ location of field in constant pool
generateFieldRef cl (TypedExpr (LocalOrFieldVar name) typ)
  = (countrCp +~ n $ newCl, loc)
    where
      loc = (newCl^.arrayCp) ! fieldRefInfo
      n = if loc > newCl^.countrCp then 1 else 0
      fieldRefInfo = FieldRefInfo { _tagCp              = TagFieldRef
                                  , _indexNameCp        = indexName
                                  , _indexNameandtypeCp = indexNameType
                                  , _desc               = ""
                                  } 
      (newCl, indexName, indexNameType) 
         = generateVarMethod cl name typ fieldRefInfo

-- | insert a method in the constant pool
generateMethodRef :: ClassFile -- ^ current constant pool
                  -> StmtExpr -- ^ method to insert in constant pool
                  -> (ClassFile -- ^ new constant pool
                     ,Int) -- ^ location of field in constant pool
generateMethodRef cl (TypedStmtExpr (MethodCall _ name _) typ)
  = (countrCp +~ n $ newCl, loc)
  where
    loc = (newCl^.arrayCp) ! methodRefInfo
    n = if loc > newCl^.countrCp then 1 else 0
    methodRefInfo = MethodRefInfo { _tagCp              = TagMethodRef
                                  , _indexNameCp        = indexName
                                  , _indexNameandtypeCp = indexNameType
                                  , _desc               = ""
                                  } 
    (newCl, indexName, indexNameType) 
       = generateVarMethod cl name typ methodRefInfo

-- | insert a interface in the constant pool
generateInterfaceRef = undefined

-- | insert a string in the constant pool
generateString = undefined

-- | inserts a integer in the constant pool
generateInteger :: ClassFile -- ^ current constant pool
                -> Int -- ^ Int to insert in the constant pool
                -> (ClassFile -- ^ new constant pool
                   ,Int) -- ^ location of int in constant pool
generateInteger cl int 
  = (countrCp +~ n $ newCl, loc)
  where
    loc = (newCl^.arrayCp) ! intInfo
    n = if loc > newCl^.countrCp then 1 else 0
    intInfo = IntegerInfo { _tagCp  = TagInteger
                          , _numiCp = int 
                          , _desc   = ""
                          }
    newCl = over arrayCp (HM.insert intInfo (cl^.countrCp+1)) cl 

-- | insert a float in the constant pool
generateFloat :: ClassFile -- ^ current constant pool
              -> Float -- ^ Float to insert in the constant pool
              -> (ClassFile -- ^ new constant pool
                 ,Int) -- ^ location of int in constant pool
generateFloat cl float 
  = (countrCp +~ n $ newCl, loc)
  where
    loc = (newCl^.arrayCp) ! floatInfo
    n = if loc > newCl^.countrCp then 1 else 0
    floatInfo = FloatInfo { _tagCp  = TagFloat
                          , _numfCp = float 
                          , _desc   = ""
                          }
    newCl = over arrayCp (HM.insert floatInfo (cl^.countrCp+1)) cl 

-- | insert a long in the constant pool
generateLong :: ClassFile -- ^ current constant pool
              -> (Int,Int) -- ^ Long to insert in the constant pool
              -> (ClassFile -- ^ new constant pool
                 ,Int) -- ^ location of int in constant pool
generateLong cl (int1,int2)
  = (countrCp +~ n $ newCl, loc)
  where
    loc = (newCl^.arrayCp) ! longInfo
    n = if loc > newCl^.countrCp then 1 else 0
    longInfo = LongInfo { _tagCp    = TagLong
                        , _numiL1Cp = int1 
                        , _numiL2Cp = int2 
                        , _desc     = ""
                        }
    newCl = over arrayCp (HM.insert longInfo (cl^.countrCp+1)) cl 

-- | insert a double in the constant pool
generateDouble :: ClassFile -- ^ current constant pool
              -> (Int,Int) -- ^ Double to insert in the constant pool
              -> (ClassFile -- ^ new constant pool
                 ,Int) -- ^ location of int in constant pool
generateDouble cl (int1,int2)
  = (countrCp +~ n $ newCl, loc)
  where
    loc = (newCl^.arrayCp) ! doubleInfo
    n = if loc > newCl^.countrCp then 1 else 0
    doubleInfo = DoubleInfo { _tagCp    = TagDouble
                            , _numiD1Cp = int1 
                            , _numiD2Cp = int2 
                            , _desc     = ""
                            }
    newCl = over arrayCp (HM.insert doubleInfo (cl^.countrCp+1)) cl 

-- | insert name and type
generateNameAndType :: ClassFile -- ^ current constant pool
                    -> String -- ^ name to insert in constant pool 
                    -> Type -- ^ type to insert in constant pool 
                    -> (ClassFile -- ^ new constant pool
                       ,Int) -- ^ location of int in constant pool
generateNameAndType cl name typ = (countrCp +~ n $ newCl, loc)
  where
    loc = (newCl^.arrayCp) ! nameTypeInfo
    n = if loc > newCl^.countrCp then 1 else 0
    nameTypeInfo = NameAndTypeInfo { _tagCp       = TagNameAndType
                                   , _indexNameCp = indexName
                                   , _indexTypeCp = indexType
                                   , _desc        = ""
                                   } 
    newCl = over arrayCp (HM.insert nameTypeInfo (cl''^.countrCp+1)) cl''
    (cl',indexName) = generateUTF8 cl name
    (cl'',indexType) = generateUTF8 cl' typ 

-- | inserts a utf8 in the constant pool
generateUTF8 :: ClassFile -- ^ current constant pool
             -> String -- ^ string to insert in the constant pool
             -> (ClassFile -- ^ new constant pool
                ,Int) -- ^ location of String in constant pool
generateUTF8 cl str = (countrCp +~ n $ newCl, loc)
  where
    loc = (newCl^.arrayCp) ! utf8info 
    n = if loc > newCl^.countrCp then 1 else 0
    utf8info = Utf8Info { _tagCp = TagUtf8
                        , _tamCp = length str
                        , _cadCp = str
                        , _desc  = ""
                        }
    newCl = over arrayCp (HM.insert utf8info (cl^.countrCp+1)) cl 

-- helper functions

generateVarMethod cl name typ refInfo = (newCl, indexName, indexNameType)
  where
    newCl = over arrayCp (HM.insert refInfo (cl''^.countrCp+1)) cl'' 
    -- Use "This" here because there is no information about the class
    (cl',indexName) = generateClass cl "This"
    (cl'',indexNameType) = generateNameAndType cl name typ 
