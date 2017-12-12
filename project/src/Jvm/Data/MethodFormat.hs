module Data.MethodFormat (
) where
import Data.Word

data Assembler = Aload0
               | Aload1
               | Aload2
               | Aload3
               | Aload { index :: Word8 } 
               | Invokespecial Word8 Word8 
               | Return
               | Iconst0
               | Iconst1
               | Iconst2
               | Iconst3
               | Iconst4
               | Iconst5
               | Bipush Word8 
               | Putfield 
                   { indexbyte1 :: Word8
                   , indexbyte2 :: Word8
                   }
               | Getfield 
                   { indexbyte1 :: Word8
                   , indexbyte2 :: Word8
                   }
               | Iadd
               | IStore0
               | IStore1 
               | IStore2 
               | IStore3 
               | IStore Word8
               | Iinc
                   { index :: Word8
                   , const :: Word8
                   }
               | New 
                   { indexbyte1 :: Word8
                   , indexbyte2 :: Word8
                   }
               | Dup
               | Astore0
               | Astore1
               | Astore2
               | Astore3
               | Astore { index :: Word8 }
               | Iload0
               | Iload1
               | Iload2
               | Iload3
               | Iload { index :: Word8 }
               | Invokevirtual
                   { indexbyte1 :: Word8
                   , indexbyte2 :: Word8
                   }
               | Areturn
               | Ireturn
               | IfIcmpEq
                   { branchbyte1 :: Word8
                   , branchbyte2 :: Word8
                   }
               | IfIcmpNe
                   { branchbyte1 :: Word8
                   , branchbyte2 :: Word8
                   }
               | IfIcmpLt
                   { branchbyte1 :: Word8
                   , branchbyte2 :: Word8
                   }
               | IfIcmpGe
                   { branchbyte1 :: Word8
                   , branchbyte2 :: Word8
                   }
               | IfIcmpLe
                   { branchbyte1 :: Word8
                   , branchbyte2 :: Word8
                   }

type Code = [Assembler]
