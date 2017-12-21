module Codegen.GenerateConstantPool where 
import Codegen.Data.ClassFormat
import ABSTree
import Data.Word
import Prelude hiding ((!))
import qualified Data.HashMap.Lazy as HM
import Data.HashMap.Lazy ((!))

{-
 
Use this module to insert a constant in the constant pool

-}
-- | insert a class in the constant pool
generateClass hm str index = undefined


-- | insert a field variable in the constant pool
generateFieldRef :: CPInfos -- ^ current constant pool
                 -> Expr -- ^ field to insert in constant pool
                 -> Word8 -- ^ current highest index in constant pool
                 -> (CPInfos -- ^ new constant pool
                    ,Word8 -- ^ location of field in constant pool
                    ,Word8) -- ^ new highest index in constant pool 
generateFieldRef hm (TypedExpr (LocalOrFieldVar name) typ) index 
  = (newHM
    , newHM ! fieldRefInfo
    , newIndex
    )
  where
    fieldRefInfo = FieldRefInfo { indexNameCp        = indexName
                                , indexNameandtypeCp = indexNameType
                                , desc               = ""
                                } 
    (newHM,indexName,indexNameType,newIndex) 
       = generateVarMethod hm index name typ fieldRefInfo

-- | insert a method in the constant pool
generateMethodRef :: CPInfos -- ^ current constant pool
                  -> StmtExpr -- ^ method to insert in constant pool
                  -> Word8 -- ^ current highest index in constant pool
                  -> (CPInfos -- ^ new constant pool
                     ,Word8 -- ^ location of field in constant pool
                     ,Word8) -- ^ new highest index in constant pool 
generateMethodRef hm (TypedStmtExpr (MethodCall _ name _) typ) index 
  = (newHM
    , newHM ! methodRefInfo
    , newIndex
    )
  where
    methodRefInfo = MethodRefInfo { indexNameCp        = indexName
                                  , indexNameandtypeCp = indexNameType
                                  , desc               = ""
                                  } 
    (newHM,indexName,indexNameType,newIndex) 
       = generateVarMethod hm index name typ methodRefInfo

-- | insert a interface in the constant pool
generateInterfaceRef = undefined

-- | insert a string in the constant pool
generateString = undefined

-- | inserts a integer in the constant pool
generateInteger :: CPInfos -- ^ current constant pool
                -> Int -- ^ Int to insert in the constant pool
                -> Word8 -- ^ current highest index in constant pool
                -> (CPInfos -- ^ new constant pool
                   ,Word8 -- ^ location of int in constant pool
                   ,Word8) -- ^ new highest index in constant pool 
generateInteger hm int index = (newHM , newHM ! intInfo, newIndex)
  where
    intInfo = IntegerInfo { numiCp = int 
                           , desc  = ""
                           }
    newHM = HM.insert intInfo (index+1) hm
    newIndex = max (newHM ! intInfo) index

-- | insert a float in the constant pool
generateFloat = undefined

-- | insert a long in the constant pool
generateLong = undefined

-- | insert a double in the constant pool
generateDouble = undefined

-- | insert name and type
generateNameAndType :: CPInfos -- ^ current constant pool
                    -> String -- ^ name to insert in constant pool 
                    -> Type -- ^ type to insert in constant pool 
                    -> Word8 -- ^ current highest index in constant pool
                    -> (CPInfos -- ^ new constant pool
                       ,Word8 -- ^ location of int in constant pool
                       ,Word8) -- ^ new highest index in constant pool 
generateNameAndType hm name typ index 
  = (newHM
    , newHM ! nameTypeInfo
    , newIndex
    )
  where
    nameTypeInfo = NameAndTypeInfo { indexNameCp = indexName
                                   , indexTypeCp = indexType
                                   , desc        = ""
                                   } 
    newHM = HM.insert nameTypeInfo (newIndex+1) hm''
    (hm',indexName,maxIndex') = generateUTF8 hm name index
    (hm'',indexType,maxIndex'') 
        = generateUTF8 hm' typ $ index + 1
    newIndex = maximum [index, newHM ! nameTypeInfo 
                       , maxIndex', maxIndex''
                       ]

-- | inserts a utf8 in the constant pool
generateUTF8 :: CPInfos -- ^ current constant pool
             -> String -- ^ string to insert in the constant pool
             -> Word8 -- ^ current highest index in constant pool
             -> (CPInfos -- ^ new constant pool
                ,Word8 -- ^ location of String in constant pool
                ,Word8) -- ^ new highest index in constant pool 
generateUTF8 hm str index = (newHM , newHM ! utf8info, newIndex)
  where
    utf8info = Utf8Info { tamCp = length str
                        , cadCp = str
                        , desc  = ""
                        }
    newHM = HM.insert utf8info (index+1) hm
    newIndex = max (newHM ! utf8info) index

-- helper functions

generateVarMethod hm index name typ refInfo = 
  (newHM, indexName, indexNameType, newIndex)
    where
      newHM = HM.insert refInfo (newIndex+1) hm''
      -- Use "This" here because there is no information about the class
      (hm',indexName,maxIndex') = generateClass hm "This" index
      (hm'',indexNameType,maxIndex'') = generateNameAndType hm name typ index
      newIndex = maximum [index, newHM ! refInfo 
                       , maxIndex', maxIndex''
                       ]
