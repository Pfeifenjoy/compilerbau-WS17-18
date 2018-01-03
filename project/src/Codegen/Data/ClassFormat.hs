{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TemplateHaskell #-}

module Codegen.Data.ClassFormat where

import GHC.Generics (Generic)
import Data.Hashable
import Data.Word
import Control.Lens
import qualified Data.HashMap.Lazy as HM
import qualified Data.ByteString.Lazy as BS

-- class file format
data ClassFile = ClassFile { _magic           :: Magic
                           , _minver          :: MinorVersion
                           , _maxver          :: MajorVersion
                           , _countrCp        :: ConstantPoolCount
                           , _arrayCp         :: CPInfos
                           , _acfg            :: AccessFlags
                           , _this            :: ThisClass
                           , _super           :: SuperClass
                           , _countInterfaces :: InterfacesCount
                           , _arrayInterfaces :: Interfaces
                           , _countFields     :: FieldsCount
                           , _arrayFields     :: FieldInfos
                           , _countMethods    :: MethodsCount
                           , _arrayMethods    :: MethodInfos
                           , _countAttributes :: AttributesCount
                           , _arrayAttributes :: AttributeInfos
                           -- InnerClasses(<=1), EnclosingMethod(<=1), signature,
                           -- SourceFile(<=1), SourceDebugExtension(<=1),
                           -- synthetic(<=1), deprecated,
                           -- Runtime(In)Visible(Parameter)Annotations(<=1),
                           -- BootstrapMethods
                           }
                    deriving Show

-- instance Show ClassFile where
--          show (ClassFile  magic  minver  maxver  count_cp  array_cp  acfg  this  super  count_interfaces  array_interfaces  count_fields  array_fields  count_methods  array_methods  count_attributes  array_attributes) = "magic = 0x CAFEBABE\n"  ++ (show minver) ++ "\n"  ++ (show maxver) ++ "\n"  ++ "constant_pool_count = " ++ (show count_cp) ++ "\n"  ++ (showCP_Infos array_cp 1) ++ "\n"  ++ (show acfg) ++ "\n"  ++ (show this) ++ "\n"  ++ (show super) ++ "\n\nInterfaces\ncount_interfaces "  ++ (show count_interfaces) ++ "\n"  ++ (show array_interfaces) ++ "\n\nFields\ncount_fields "  ++ (show count_fields) ++ "\n"  ++ (show array_fields) ++ "\n"  ++ (show count_methods) ++ "\n\nMethods\ncount_Methods "  ++ (show array_methods) ++ "\n"  ++ (show count_attributes) ++ "\n"  ++ (show array_attributes)
         

type CPInfos        = HM.HashMap CPInfo Word8
type Interfaces     = [Interface]
type FieldInfos     = [FieldInfo]
type MethodInfos    = [MethodInfo]
type AttributeInfos = [AttributeInfo]

data Magic = Magic
        deriving Show

newtype MinorVersion = MinorVersion {
                        _numMinVer:: Int
                    }
        deriving Show

newtype MajorVersion = MajorVersion {
                        _numMaxVer:: Int
                    }
        deriving Show

data CPInfo = 
          ClassInfo
                { _indexCp              :: IndexConstantPool
                , _desc                 :: String -- comment in Bytcode
                }
        | FieldRefInfo 
                { _indexNameCp          :: IndexConstantPool
                , _indexNameandtypeCp   :: IndexConstantPool
                , _desc                 :: String -- comment in Bytcode
                }
        | MethodRefInfo 
                { _indexNameCp          :: IndexConstantPool
                , _indexNameandtypeCp   :: IndexConstantPool
                , _desc                 :: String-- comment in Bytcode
                }
        | InterfaceMethodRefInfo 
                { _indexNameCp          :: IndexConstantPool
                , _indexNameandtypeCp   :: IndexConstantPool
                , _desc                 :: String -- comment in Bytcode
                }
        | StringInfo
                { _indexCp              :: IndexConstantPool
                , _desc                 :: String -- comment in Bytcode
                }
        | IntegerInfo 
                { _numiCp               :: Int
                , _desc                 :: String -- comment in Bytcode
                }
        | FloatInfo 
                { _numfCp               :: Float
                , _desc                 :: String -- comment in Bytcode
                }
        | LongInfo 
                { _numiL1Cp             :: Int
                , _numiL2Cp             :: Int
                , _desc                 :: String -- comment in Bytcode
                }
        | DoubleInfo 
                { _numiD1Cp             :: Int
                , _numiD2Cp             :: Int
                , _desc                 :: String -- comment in Bytcode
                }
        | NameAndTypeInfo 
                { _indexNameCp          :: IndexConstantPool
                , _indexTypeCp          :: IndexConstantPool
                , _desc                 :: String -- comment in Bytcode
                }
        | Utf8Info 
                { _tamCp                :: Int    -- length of string
                , _cadCp                :: String -- name of string
                , _desc                 :: String -- comment in Bytcode
                }
            deriving (Show,Eq,Generic)

instance Hashable CPInfo 

showCPInfos :: [CPInfo] -> Int -> String
showCPInfos [] n = ""
showCPInfos (x : xss) n = show n ++ "|" ++ show x ++ "\n" ++ showCPInfos xss (n+1)


newtype AccessFlags = AccessFlags [Int]
            deriving Show

accPublic    :: Int
accPublic     = 1

accPrivate   :: Int
accPrivate    = 2

accProtected :: Int
accProtected  = 4

accStatic    :: Int
accStatic     = 8

accFinal     :: Int
accFinal      = 16

accSuperSynchronized     :: Int
accSuperSynchronized      = 32

accVolatileBridge  :: Int
accVolatileBridge   = 64

accTransientVarargs :: Int
accTransientVarargs  = 128

accNative:: Int
accNative = 256

accInterface :: Int
accInterface  = 512

accAbstract  :: Int
accAbstract   = 1024

accStrict:: Int
accStrict = 2048

accSynthetic :: Int
accSynthetic  = 4096

accAnnotation:: Int
accAnnotation = 8192

accEnum   :: Int
accEnum    = 16384

newtype ThisClass = ThisClass {
                    _indexTh :: IndexConstantPool
                 }
        deriving Show

newtype SuperClass = SuperClass {
                    _indexSp :: IndexConstantPool
                  }
        deriving Show

newtype Interface = Interface {
                    _indexIf :: IndexConstantPool
                  }
        deriving Show

data FieldInfo = FieldInfo 
                        { _afFi          :: AccessFlags
                        , _indexNameFi   :: IndexConstantPool       -- name_index
                        , _indexDescrFi  :: IndexConstantPool       -- descriptor_index
                        , _tamFi         :: Int                     -- count_attributte
                        , _arrayAttrFi   :: AttributeInfos
                        -- optional: ConstantValue(<=1), synthetic(<=1), deprecated(<=1),
                        -- Signature
                        -- Runtime(In)Visible(Parameter)Annotations(<=1)
                        }
            deriving Show

data MethodInfo = MethodInfo 
                        { _afMi          :: AccessFlags
                        , _indexNameMi   :: IndexConstantPool       -- name_index
                        , _indexDescrMi  :: IndexConstantPool       -- descriptor_index
                        , _tamMi         :: Int                     -- attributes_count
                        , _arrayAttrMi   :: AttributeInfos
                        -- Exceptions(<=1) code(<=1), synthetic(<=1) deprecated(<=1),
                        -- Signature
                        -- Runtime(In)Visible(Parameter)Annotations(<=1),
                        -- AnnotationsDefault 
                        }
                    deriving Show

data AttributeInfo =
        AttributeGeneric 
            { _indexNameAttr            :: IndexConstantPool
            , _tamLenAttr               :: Int
            , _restAttr                 :: BS.ByteString
            }

      | AttributeConstantValue 
            { _indexNameAttr            :: IndexConstantPool              -- attribute_name_index
            , _tamAttr                  :: Int                              -- attribute_length
            , _indexValueAttr           :: IndexConstantPool              -- constantvalue_index
            }
      | AttributeCode 
            { _indexNameAttr            :: IndexConstantPool              -- attribute_name_index
            , _tamLenAttr               :: Int                              -- attribute_length
            , _lenStackAttr             :: Int                              -- max_stack
            , _lenLocalAttr             :: Int                              -- max_local
            , _tamCodeAttr              :: Int                              -- code_length
            , _arrayCodeAttr            :: ListaInt                         -- code como array de bytes
            , _tamExAttr                :: Int                              -- exceptions_length
            , _arrayExAttr              :: Tupla4Int                        -- no usamos
            , _tamAtrrAttr              :: Int                              -- attributes_count
            , _arrayAttrAttr            :: AttributeInfos
            -- LineNumberTable, LocalVariableTable, LocalVariableTypeTable,
            -- deprecated, StackMapTable(<=1)
            }
      
      | AttributeExceptions
            { _indexNameAttr            :: IndexConstantPool              -- attribute_name_index
            , _tamLenAttr               :: Int                              -- attribute_length
            , _tamNumExAttr             :: Int                              -- number of exceptions
            , _exceptionIndexTable      :: [Int]                            -- exception_index_table 
            }
      
      | AttributeInnerClasses
            { _indexNameAttr            :: IndexConstantPool              -- attribute_name_index
            , _tamLenAttr               :: Int                              -- attribute_length
            , _tamClasses               :: Int                              -- number_classes
            , _arrayClasses             :: [(Int,Int,Int,AccessFlags)]       -- classes
            }
      
      | AttributeSynthetic
            { _indexNameAttr            :: IndexConstantPool              -- attribute_name_index
            , _tamLenAttr               :: Int                              -- attribute_length
            }
      
      | AttributeSourceFile 
            { _indexNameAttr            :: IndexConstantPool              -- attribute_name_index
            , _tamLenAttr               :: Int                              -- attribute_length
            , _indexSrcAttr             :: IndexConstantPool              -- sourcefile_index
            }
            
      | AttributeLineNumberTable 
            { _indexNameAttr            :: IndexConstantPool              -- attribute_name_index
            , _tamLenAttr               :: Int                              -- attribute_length
            , _tamTableAttr             :: Int                              -- lineNumberTable_length
            , _arrayLineAttr            :: Tupla2Int                        -- (start_pc, line_number)
            }
      | AttributeLocalVariableTable 
            { _indexNameAttr            :: IndexConstantPool              -- attribute_name_index
            , _tamLenAttr               :: Int                              -- attribute_length
            , _tamTableAttr             :: Int                              -- local_varible_table_length
            , _arrayVarAttr             :: Tupla5Int                        -- (start_pc, length, name_index, descriptor_index, inlinedex)
            }
      | AttributeDeprecated
            { _indexNameAttr            :: IndexConstantPool              -- attribute_name_index
            , _tamLenAttr               :: Int                              -- attribute_length
            }
         deriving Show

type Tupla5Int = [(Int, Int, Int, Int, Int)]
type Tupla2Int = [(Int, Int)]
type Tupla4Int = [(Int, Int, Int, Int)]
type ListaInt  = [Int]
type ConstantPoolCount  = Word8 
type InterfacesCount    = Word8 
type FieldsCount        = Word8 
type MethodsCount       = Word8 
type AttributesCount    = Word8 
type IndexConstantPool = Word8 

makeLenses ''ClassFile
makeLenses ''MinorVersion
makeLenses ''MajorVersion
makeLenses ''CPInfo
makeLenses ''AccessFlags
makeLenses ''ThisClass
makeLenses ''SuperClass
makeLenses ''Interface
makeLenses ''FieldInfo
makeLenses ''MethodInfo
makeLenses ''AttributeInfo
