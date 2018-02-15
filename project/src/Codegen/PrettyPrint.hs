module Codegen.PrettyPrint where

import Codegen.Data.ClassFormat
import Codegen.Data.Assembler

instance Show ClassFormt where
  show ClassFile { _magic           = _
                 , _minver          = minorVersion
                 , _maxver          = majorVersion
                 , _countrCp        = constantPoolCount
                 , _arrayCp         = cPInfos
                 , _acfg            = accessFlags
                 , _this            = thisClass
                 , _super           = superClass
                 , _countInterfaces = interfacesCount
                 , _arrayInterfaces = interfaces
                 , _countFields     = fieldsCount
                 , _arrayFields     = fieldInfos
                 , _countMethods    = methodsCount
                 , _arrayMethods    = methodInfos
                 , _countAttributes = attributesCount
                 , _arrayAttributes = attributeInfos
                 }
      =  "Magic\n"
      ++ "MinorVersion = " ++ show minorVersion ++ "\n"
      ++ "MajorVersion = " ++ show majorVersion ++ "\n"
      ++ "ConstantPoolCount =" ++ show constantPoolCount ++ "\n"
      ++ "CPInfos :\n" ++ show cPInfos ++ "\n"
      ++ "AccessFlags =" ++ show accessFlags ++ "\n"
      ++ "ThisClass =" ++ show thisClass ++ "\n"
      ++ "SuperClass =" ++ show superClass ++ "\n"
      ++ "InterfacesCount =" ++ show interfacesCount ++ "\n"
      ++ if interfacesCount == 0 then "" 
         else "Interfaces =" ++ show interfaces ++ "\n"
      ++ "FieldsCount =" ++ show fieldsCount ++ "\n"
      ++ if fieldCount == 0 then "" 
         else "FieldInfos:\n" ++ show fieldInfos ++ "\n"
      ++ "MethodsCount =" ++ show methodsCount ++ "\n"
      ++ if methodsCount == 0 then "" 
         else "MethodInfos:\n" ++ show methodInfos ++ "\n"
      ++ "AttributesCount:\n" ++ show attributesCount ++ "\n"
      ++ if methodsCount == 0 then "" 
         else "AttributeInfos:\n" ++ show attributeInfos ++ "\n"
