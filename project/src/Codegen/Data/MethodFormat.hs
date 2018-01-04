module Codegen.Data.MethodFormat (
) where
import Data.Word
import qualified Data.ByteString.Lazy as BS

data Assembler = Aload0
               | Aload1
               | Aload2
               | Aload3
               | Aload 
                   { index :: Word8 } 
               | Invokespecial 
                   { indexbyte1 :: Word8
                   , indexbyte2 :: Word8
                   }
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
               | Astore 
                   { index :: Word8 }
               | Iload0
               | Iload1
               | Iload2
               | Iload3
               | Iload 
                   { index :: Word8 }
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
               | IfIcmpGt
                   { branchbyte1 :: Word8
                   , branchbyte2 :: Word8
                   }
               | IfIcmpLe
                   { branchbyte1 :: Word8
                   , branchbyte2 :: Word8
                   }

type Code = [Assembler]

-- TODO check if it should be [int] instead of ByteString
code2BS :: Code -> BS.ByteString
code2BS (Aload0:xs)                   = 0x2a `BS.cons` code2BS xs
code2BS (Aload1:xs)                   = 0x2b `BS.cons` code2BS xs
code2BS (Aload2:xs)                   = 0x2c `BS.cons` code2BS xs
code2BS (Aload3:xs)                   = 0x2d `BS.cons` code2BS xs
code2BS (Aload ind :xs)               = 0x19 `BS.cons` ind 
                                             `BS.cons` code2BS xs
code2BS (Invokespecial ind1 ind2 :xs) = 0xb7 `BS.cons` ind1 
                                             `BS.cons` ind2
                                             `BS.cons` code2BS xs
code2BS (Return:xs)                   = 0xb1 `BS.cons` code2BS xs
code2BS (Iconst0:xs)                  = 0x3  `BS.cons` code2BS xs
code2BS (Iconst1:xs)                  = 0x4  `BS.cons` code2BS xs
code2BS (Iconst2:xs)                  = 0x5  `BS.cons` code2BS xs
code2BS (Iconst3:xs)                  = 0x6  `BS.cons` code2BS xs
code2BS (Iconst4:xs)                  = 0x7  `BS.cons` code2BS xs
code2BS (Iconst5:xs)                  = 0x8  `BS.cons` code2BS xs
code2BS (Bipush ind :xs)              = 0x10 `BS.cons` ind 
                                             `BS.cons` code2BS xs
code2BS (Putfield  b1 b2:xs)          = 0xb5 `BS.cons` b1 
                                             `BS.cons` b2 
                                             `BS.cons` code2BS xs
code2BS (Getfield  b1 b2:xs)          = 0xb4 `BS.cons` b1 
                                             `BS.cons` b2 
                                             `BS.cons` code2BS xs
code2BS (Iadd:xs)                     = 0x60 `BS.cons` code2BS xs
code2BS (IStore0:xs)                  = 0x59 `BS.cons` code2BS xs
code2BS (IStore1 :xs)                 = 0x60 `BS.cons` code2BS xs
code2BS (IStore2 :xs)                 = 0x61 `BS.cons` code2BS xs
code2BS (IStore3 :xs)                 = 0x62 `BS.cons` code2BS xs
code2BS (IStore ind:xs)               = 0x36 `BS.cons` ind 
                                             `BS.cons` code2BS xs
code2BS (Iinc ind con:xs)             = 0x84 `BS.cons` ind 
                                             `BS.cons` con 
                                             `BS.cons` code2BS xs
code2BS (New  ind1 ind2:xs)           = 0xbb `BS.cons` ind1 
                                             `BS.cons` ind2 
                                             `BS.cons` code2BS xs
code2BS (Dup:xs)                      = 0x59 `BS.cons` code2BS xs
code2BS (Astore0:xs)                  = 0x75 `BS.cons` code2BS xs
code2BS (Astore1:xs)                  = 0x76 `BS.cons` code2BS xs
code2BS (Astore2:xs)                  = 0x77 `BS.cons` code2BS xs
code2BS (Astore3:xs)                  = 0x78 `BS.cons` code2BS xs
code2BS (Astore ind :xs)              = 0x3a `BS.cons` ind 
                                             `BS.cons` code2BS xs
code2BS (Iload0:xs)                   = 0x1a `BS.cons` code2BS xs
code2BS (Iload1:xs)                   = 0x1b `BS.cons` code2BS xs
code2BS (Iload2:xs)                   = 0x1c `BS.cons` code2BS xs
code2BS (Iload3:xs)                   = 0x1d `BS.cons` code2BS xs
code2BS (Iload ind :xs)               = 0x15 `BS.cons` ind 
                                             `BS.cons` code2BS xs
code2BS (Invokevirtual ind1 ind2:xs)  = 0xb6 `BS.cons` ind1 
                                             `BS.cons` ind2 
                                             `BS.cons` code2BS xs
code2BS (Areturn:xs)                  = 0xb0 `BS.cons` code2BS xs
code2BS (Ireturn:xs)                  = 0xac `BS.cons` code2BS xs
code2BS (IfIcmpEq b1 b2:xs)           = 0x9f `BS.cons` b1 
                                             `BS.cons` b2 
                                             `BS.cons` code2BS xs
code2BS (IfIcmpNe b1 b2:xs)           = 0xa0 `BS.cons` b1 
                                             `BS.cons` b2 
                                             `BS.cons` code2BS xs
code2BS (IfIcmpLt b1 b2:xs)           = 0xa1 `BS.cons` b1 
                                             `BS.cons` b2 
                                             `BS.cons` code2BS xs
code2BS (IfIcmpGe b1 b2:xs)           = 0xa2 `BS.cons` b1 
                                             `BS.cons` b2 
                                             `BS.cons` code2BS xs
code2BS (IfIcmpGt b1 b2:xs)           = 0xa3 `BS.cons` b1 
                                             `BS.cons` b2 
                                             `BS.cons` code2BS xs
code2BS (IfIcmpLe b1 b2:xs)           = 0xa4 `BS.cons` b1 
                                             `BS.cons` b2 
                                             `BS.cons` code2BS xs
