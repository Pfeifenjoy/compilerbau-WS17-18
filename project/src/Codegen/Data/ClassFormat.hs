module Jvm.Data.ClassFormat where
import qualified Data.ByteString.Lazy as BS

-- class file format
data ClassFile = ClassFile { magic            :: Magic
                           , minver           :: MinorVersion
                           , maxver           :: MajorVersion
                           , countrCp         :: ConstantPoolCount
                           , arrayCp          :: CPInfos
                           , acfg             :: AccessFlags
                           , this             :: ThisClass
                           , super            :: SuperClass
                           , countInterfaces  :: InterfacesCount
                           , arrayInterfaces  :: Interfaces
                           , countFields      :: FieldsCount
                           , arrayFields      :: FieldInfos
                           , countMethods     :: MethodsCount
                           , arrayMethods     :: MethodInfos
                           , countAttributes  :: AttributesCount
                           , arrayAttributes  :: AttributeInfos
                           }
                    deriving Show

-- instance Show ClassFile where
--          show (ClassFile  magic  minver  maxver  count_cp  array_cp  acfg  this  super  count_interfaces  array_interfaces  count_fields  array_fields  count_methods  array_methods  count_attributes  array_attributes) = "magic = 0x CAFEBABE\n"  ++ (show minver) ++ "\n"  ++ (show maxver) ++ "\n"  ++ "constant_pool_count = " ++ (show count_cp) ++ "\n"  ++ (showCP_Infos array_cp 1) ++ "\n"  ++ (show acfg) ++ "\n"  ++ (show this) ++ "\n"  ++ (show super) ++ "\n\nInterfaces\ncount_interfaces "  ++ (show count_interfaces) ++ "\n"  ++ (show array_interfaces) ++ "\n\nFields\ncount_fields "  ++ (show count_fields) ++ "\n"  ++ (show array_fields) ++ "\n"  ++ (show count_methods) ++ "\n\nMethods\ncount_Methods "  ++ (show array_methods) ++ "\n"  ++ (show count_attributes) ++ "\n"  ++ (show array_attributes)
         

type CPInfos        = [CPInfo]
type Interfaces     = [Interface]
type FieldInfos     = [FieldInfo]
type MethodInfos    = [MethodInfo]
type AttributeInfos = [AttributeInfo]

data Magic = Magic
        deriving Show

newtype MinorVersion = MinorVersion {
                        numMinVer :: Int
                    }
        deriving Show

newtype MajorVersion = MajorVersion {
                        numMaxVer :: Int
                    }
        deriving Show

data CPInfo = 
          ClassInfo
                { tagCp                 :: Tag
                , indexCp               :: IndexConstantPool
                , desc                  :: String
                }
        | FieldRefInfo 
                { tagCp                 :: Tag
                , indexNameCp           :: IndexConstantPool
                , indexNameandtypeCp    :: IndexConstantPool
                , desc                  :: String
                }
        | MethodRefInfo 
                { tagCp                 :: Tag
                , indexNameCp           :: IndexConstantPool
                , indexNameandtypeCp    :: IndexConstantPool
                , desc                  :: String
                }
        | InterfaceMethodRefInfo 
                { tagCp                 :: Tag
                , indexNameCp           :: IndexConstantPool
                , indexNameandtypeCp    :: IndexConstantPool
                , desc                  :: String
                }
        | StringInfo
                { tagCp                 :: Tag
                , indexCp               :: IndexConstantPool
                , desc                  :: String
                }
        | IntegerInfo 
                { tagCp                 :: Tag
                , numiCp                :: Int
                , desc                  :: String
                }
        | FloatInfo 
                { tagCp                 :: Tag
                , numfCp                :: Float
                , desc                  :: String
                }
        | LongInfo 
                { tagCp                 :: Tag
                , numiL1Cp              :: Int
                , numiL2Cp              :: Int
                , desc                  :: String
                }
        | DoubleInfo 
                { tagCp                 :: Tag
                , numiD1Cp              :: Int
                , numiD2Cp              :: Int
                , desc                  :: String
                }
        | NameAndTypeInfo 
                { tagCp                 :: Tag
                , indexNameCp           :: IndexConstantPool
                , indexDescrCp          :: IndexConstantPool
                , desc                  :: String
                }
        | Utf8Info 
                { tagCp                 :: Tag
                , tamCp                 :: Int
                , cadCp                 :: String
                , desc                  :: String
                }
            deriving Show

showCPInfos :: [CPInfo] -> Int -> String
showCPInfos [] n = ""
showCPInfos (x : xss) n = show n ++ "|" ++ show x ++ "\n" ++ showCPInfos xss (n+1)

data Tag = TagClass              
         | TagFieldRef
         | TagMethodRef
         | TagInterfaceMethodRef
         | TagString
         | TagInteger
         | TagFloat
         | TagLong
         | TagDouble
         | TagNameAndType
         | TagUtf8
        deriving Show

newtype AccessFlags = AccessFlags [Int]
            deriving Show

accPublic     :: Int
accPublic     = 1

accPrivate    :: Int
accPrivate    = 2

accProtected  :: Int
accProtected  = 4

accStatic     :: Int
accStatic     = 8

accFinal      :: Int
accFinal      = 16

accSuperSynchronized      :: Int
accSuperSynchronized      = 32

accVolatileBridge   :: Int
accVolatileBridge   = 64

accTransientVarargs  :: Int
accTransientVarargs  = 128

accNative :: Int
accNative = 256

accInterface  :: Int
accInterface  = 512

accAbstract   :: Int
accAbstract   = 1024

accStrict :: Int
accStrict = 2048

accSynthetic  :: Int
accSynthetic  = 4096

accAnnotation :: Int
accAnnotation = 8192

accEnum    :: Int
accEnum    = 16384

newtype ThisClass = ThisClass {
                    indexTh  :: IndexConstantPool
                 }
        deriving Show

newtype SuperClass = SuperClass {
                    indexSp  :: IndexConstantPool
                  }
        deriving Show

newtype Interface = Interface {
                    indexIf  :: IndexConstantPool
                  }
        deriving Show

data FieldInfo = FieldInfo 
                        { afFi           :: AccessFlags
                        , indexNameFi    :: IndexConstantPool       -- name_index
                        , indexDescrFi   :: IndexConstantPool       -- descriptor_index
                        , tamFi          :: Int                     -- count_attributte
                        , arrayAttrFi    :: AttributeInfos
                        }
            deriving Show

data MethodInfo = MethodInfo 
                        { afMi           :: AccessFlags
                        , indexNameMi    :: IndexConstantPool       -- name_index
                        , indexDescrMi   :: IndexConstantPool       -- descriptor_index
                        , tamMi          :: Int                       -- attributes_count
                        , arrayAttrMi    :: AttributeInfos
                        }
                    deriving Show

data AttributeInfo =
        AttributeGeneric 
            { indexNameAttr             :: IndexConstantPool
            , tamLenAttr                :: Int
            , restAttr                  :: BS.ByteString
            }

      | AttributeConstantValue 
            { indexNameAttr             :: IndexConstantPool              -- attribute_name_index
            , tamAttr                   :: Int                              -- attribute_length
            , indexValueAttr            :: IndexConstantPool              -- constantvalue_index
            }
      | AttributeCode 
            { indexNameAttr             :: IndexConstantPool              -- attribute_name_index
            , tamLenAttr                :: Int                              -- attribute_length
            , lenStackAttr              :: Int                              -- max_stack
            , lenLocalAttr              :: Int                              -- max_local
            , tamCodeAttr               :: Int                              -- code_length
            , arrayCodeAttr             :: ListaInt                         -- code como array de bytes
            , tamExAttr                 :: Int                              -- exceptions_length
            , arrayExAttr               :: Tupla4Int                        -- no usamos
            , tamAtrrAttr               :: Int                              -- attributes_count
            , arrayAttrAttr             :: AttributeInfos
            }
      
      | AttributeExceptions
            { indexNameAttr             :: IndexConstantPool              -- attribute_name_index
            , tamLenAttr                :: Int                              -- attribute_length
            , tamNumExAttr              :: Int                              -- number of exceptions
            , exceptionIndexTable       :: [Int]                            -- exception_index_table 
            }
      
      | AttributeInnerClasses
            { indexNameAttr             :: IndexConstantPool              -- attribute_name_index
            , tamLenAttr                :: Int                              -- attribute_length
            , tamClasses                :: Int                              -- number_classes
            , arrayClasses              :: [(Int,Int,Int,AccessFlags)]       -- classes
            }
      
      | AttributeSynthetic
            { indexNameAttr             :: IndexConstantPool              -- attribute_name_index
            , tamLenAttr                :: Int                              -- attribute_length
            }
      
      | AttributeSourceFile 
            { indexNameAttr             :: IndexConstantPool              -- attribute_name_index
            , tamLenAttr                :: Int                              -- attribute_length
            , indexSrcAttr              :: IndexConstantPool              -- sourcefile_index
            }
            
      | AttributeLineNumberTable 
            { indexNameAttr             :: IndexConstantPool              -- attribute_name_index
            , tamLenAttr                :: Int                              -- attribute_length
            , tamTableAttr              :: Int                              -- lineNumberTable_length
            , arrayLineAttr             :: Tupla2Int                        -- (start_pc, line_number)
            }
      | AttributeLocalVariableTable 
            { indexNameAttr             :: IndexConstantPool              -- attribute_name_index
            , tamLenAttr                :: Int                              -- attribute_length
            , tamTableAttr              :: Int                              -- local_varible_table_length
            , arrayVarAttr              :: Tupla5Int                        -- (start_pc, length, name_index, descriptor_index, inlinedex)
            }
      | AttributeDeprecated
            { indexNameAttr             :: IndexConstantPool              -- attribute_name_index
            , tamLenAttr                :: Int                              -- attribute_length
            }
         deriving Show

type Tupla5Int = [(Int, Int, Int, Int, Int)]
type Tupla2Int = [(Int, Int)]
type Tupla4Int = [(Int, Int, Int, Int)]
type ListaInt  = [Int]
type ConstantPoolCount  = Int
type InterfacesCount    = Int
type FieldsCount        = Int
type MethodsCount       = Int
type AttributesCount    = Int
type IndexConstantPool = Int


