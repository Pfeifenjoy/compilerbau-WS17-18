{-|
This module contains a abstract assembler and function to convert it to
int, which is later translated in to byte code
-}
module Codegen.Data.Assembler where

import ABSTree(Visibility(..),Type)
import Data.Bits
import Data.Word

type Byte = Word8
type Indexbyte = Byte
type Branchbyte = Byte
type Constbyte = Byte
type Padbyte = Byte
type Lowbyte = Byte
type Highbyte = Byte
type JumpOffsetByte = Byte
type Defaultbyte = Byte
type Npairs = Byte
type MatchOffsetparisbyte = Byte
type AtypeByte = Byte
type Dimensionbyte = Byte
type Pairbyte = (Byte,Byte,Byte,Byte,Byte,Byte,Byte,Byte)

data Assembler
  = Nop
  | AconstNull
  | IconstM1
  | Iconst0
  | Iconst1
  | Iconst2
  | Iconst3
  | Iconst4
  | Iconst5
  | Lconst0
  | Lconst1
  | Fconst0
  | Fconst1
  | Fconst2
  | Dconst0
  | Dconst1
  | Bipush Indexbyte
  | Sipush Byte Byte
  | Ldc Indexbyte
  | LdcW Indexbyte Indexbyte
  | Ldc2W Indexbyte Indexbyte
  | Iload Indexbyte
  | Lload Indexbyte
  | Fload Indexbyte
  | Dload Indexbyte
  | Aload Indexbyte
  | Iload0
  | Iload1
  | Iload2
  | Iload3
  | Lload0
  | Lload1
  | Lload2
  | Lload3
  | Fload0
  | Fload1
  | Fload2
  | Fload3
  | Dload0
  | Dload1
  | Dload2
  | Dload3
  | Aload0
  | Aload1
  | Aload2
  | Aload3
  | Iaload
  | Laload
  | Faload
  | Daload
  | Aaload
  | Baload
  | Caload
  | Saload
  | Istore Indexbyte
  | Lstore Indexbyte
  | Fstore Indexbyte
  | Dstore Indexbyte
  | Astore Indexbyte
  | Istore0
  | Istore1
  | Istore2
  | Istore3
  | Lstore0
  | Lstore1
  | Lstore2
  | Lstore3
  | Fstore0
  | Fstore1
  | Fstore2
  | Fstore3
  | Dstore0
  | Dstore1
  | Dstore2
  | Dstore3
  | Astore0
  | Astore1
  | Astore2
  | Astore3
  | Iastore
  | Lastore
  | Fastore
  | Dastore
  | Aastore
  | Bastore
  | Castore
  | Sastore
  | Pop
  | Pop2
  | Dup
  | DupX1
  | DupX2
  | Dup2
  | Dup2X1
  | Dup2X2
  | Swap
  | Iadd
  | Ladd
  | Fadd
  | Dadd
  | Isub
  | Lsub
  | Fsub
  | Dsub
  | Imul
  | Lmul
  | Fmul
  | Dmul
  | Idiv
  | Ldiv
  | Fdiv
  | Ddiv
  | Irem
  | Lrem
  | Frem
  | Drem
  | Ineg
  | Lneg
  | Fneg
  | Dneg
  | Ishl
  | Lshl
  | Ishr
  | Lshr
  | Iushr
  | Lushr
  | Iand
  | Land
  | Ior
  | Lor
  | Ixor
  | Lxor
  | Iinc Indexbyte Constbyte
  | I2l
  | I2f
  | I2d
  | L2i
  | L2f
  | L2d
  | F2i
  | F2l
  | F2d
  | D2i
  | D2l
  | D2f
  | I2b
  | I2c
  | I2s
  | Lcmp
  | Fcmpl
  | Fcmpg
  | Dcmpl
  | Dcmpg
  | Ifeq Branchbyte Branchbyte
  | Ifne Branchbyte Branchbyte
  | Iflt Branchbyte Branchbyte
  | Ifge Branchbyte Branchbyte
  | Ifgt Branchbyte Branchbyte
  | Ifle Branchbyte Branchbyte
  | IfIcmpeq Branchbyte Branchbyte
  | IfIcmpne Branchbyte Branchbyte
  | IfIcmplt Branchbyte Branchbyte
  | IfIcmpge Branchbyte Branchbyte
  | IfIcmpgt Branchbyte Branchbyte
  | IfIcmple Branchbyte Branchbyte
  | IfAcmpeq Branchbyte Branchbyte
  | IfAcmpne Branchbyte Branchbyte
  | Goto Branchbyte Branchbyte
  | Jsr Branchbyte Branchbyte
  | Ret Indexbyte
  | Tableswitch [Padbyte]
                Defaultbyte Defaultbyte Defaultbyte Defaultbyte
                Lowbyte Lowbyte Lowbyte Lowbyte
                Highbyte Highbyte Highbyte Highbyte
                [JumpOffsetByte]
  | Lookupswitch [Padbyte]
                 Defaultbyte Defaultbyte Defaultbyte Defaultbyte
                 Npairs Npairs Npairs Npairs
                 [Pairbyte]
  | Ireturn
  | Lreturn
  | Freturn
  | Dreturn
  | Areturn
  | Return
  | Getstatic Indexbyte Indexbyte
  | Putstatic Indexbyte Indexbyte
  | Getfield Indexbyte Indexbyte
  | Putfield Indexbyte Indexbyte
  | Invokevirtual Indexbyte Indexbyte
  | Invokespecial Indexbyte Indexbyte
  | Invokestatic Indexbyte Indexbyte
  | Invokeinterface Indexbyte Indexbyte Indexbyte
  | Invokedynamic Indexbyte Indexbyte
  | New Indexbyte Indexbyte
  | Newarray AtypeByte
  | Anewarray Indexbyte Indexbyte
  | Arraylength
  | Athrow
  | Checkcast Indexbyte Indexbyte
  | Instanceof Indexbyte Indexbyte
  | Monitorenter
  | Monitorexit
  | Wide Assembler Indexbyte Indexbyte (Maybe Constbyte) (Maybe Constbyte)
  | Multianewarray Indexbyte Indexbyte [Dimensionbyte]
  | Ifnull Branchbyte Branchbyte
  | Ifnonnull Branchbyte Branchbyte
  | GotoW Branchbyte Branchbyte Branchbyte Branchbyte
  | JsrW  Branchbyte Branchbyte Branchbyte Branchbyte
  | Breakpoint
  | Impdep1
  | Impdep2
  deriving(Show,Eq)

type Code = [Assembler]

codeToByte :: Code                       -> [Word8]
codeToByte []       = []
codeToByte (Nop:xs) = 0x00 : codeToByte xs
codeToByte (AconstNull:xs) = 0x01 : codeToByte xs
codeToByte (IconstM1:xs) = 0x02 : codeToByte xs
codeToByte (Iconst0:xs) = 0x03 : codeToByte xs
codeToByte (Iconst1:xs) = 0x04 : codeToByte xs
codeToByte (Iconst2:xs) = 0x05 : codeToByte xs
codeToByte (Iconst3:xs) = 0x06 : codeToByte xs
codeToByte (Iconst4:xs) = 0x07 : codeToByte xs
codeToByte (Iconst5:xs) = 0x08 : codeToByte xs
codeToByte (Lconst0:xs) = 0x09 : codeToByte xs
codeToByte (Lconst1:xs) = 0x0a : codeToByte xs
codeToByte (Fconst0:xs) = 0x0b : codeToByte xs
codeToByte (Fconst1:xs) = 0x0c : codeToByte xs
codeToByte (Fconst2:xs) = 0x0d : codeToByte xs
codeToByte (Dconst0:xs) = 0x0e : codeToByte xs
codeToByte (Dconst1:xs) = 0x0f : codeToByte xs
codeToByte (Bipush byte:xs) = 0x10 : byte : codeToByte xs
codeToByte (Sipush byte1 byte2:xs) = 0x11 : byte1 : byte2 : codeToByte xs
codeToByte (Ldc byte:xs) = 0x12 : byte : codeToByte xs
codeToByte (LdcW byte1 byte2:xs) = 0x13 : byte1 : byte2 : codeToByte xs
codeToByte (Ldc2W byte1 byte2:xs) = 0x14 : byte1 : byte2 : codeToByte xs
codeToByte (Iload byte:xs) = 0x15 : byte : codeToByte xs
codeToByte (Lload byte:xs) = 0x16 : byte : codeToByte xs
codeToByte (Fload byte:xs) = 0x17 : byte : codeToByte xs
codeToByte (Dload byte:xs) = 0x18 : byte : codeToByte xs
codeToByte (Aload byte:xs) = 0x19 : byte : codeToByte xs
codeToByte (Iload0:xs) = 0x1a : codeToByte xs
codeToByte (Iload1:xs) = 0x1b : codeToByte xs
codeToByte (Iload2:xs) = 0x1c : codeToByte xs
codeToByte (Iload3:xs) = 0x1d : codeToByte xs
codeToByte (Lload0:xs) = 0x1e : codeToByte xs
codeToByte (Lload1:xs) = 0x1f : codeToByte xs
codeToByte (Lload2:xs) = 0x20 : codeToByte xs
codeToByte (Lload3:xs) = 0x21 : codeToByte xs
codeToByte (Fload0:xs) = 0x22 : codeToByte xs
codeToByte (Fload1:xs) = 0x23 : codeToByte xs
codeToByte (Fload2:xs) = 0x24 : codeToByte xs
codeToByte (Fload3:xs) = 0x25 : codeToByte xs
codeToByte (Dload0:xs) = 0x26 : codeToByte xs
codeToByte (Dload1:xs) = 0x27 : codeToByte xs
codeToByte (Dload2:xs) = 0x28 : codeToByte xs
codeToByte (Dload3:xs) = 0x29 : codeToByte xs
codeToByte (Aload0:xs) = 0x2a : codeToByte xs
codeToByte (Aload1:xs) = 0x2b : codeToByte xs
codeToByte (Aload2:xs) = 0x2c : codeToByte xs
codeToByte (Aload3:xs) = 0x2d : codeToByte xs
codeToByte (Iaload:xs) = 0x2e : codeToByte xs
codeToByte (Laload:xs) = 0x2f : codeToByte xs
codeToByte (Faload:xs) = 0x30 : codeToByte xs
codeToByte (Daload:xs) = 0x31 : codeToByte xs
codeToByte (Aaload:xs) = 0x32 : codeToByte xs
codeToByte (Baload:xs) = 0x33 : codeToByte xs
codeToByte (Caload:xs) = 0x34 : codeToByte xs
codeToByte (Saload:xs) = 0x35 : codeToByte xs
codeToByte (Istore byte:xs) = 0x36 : byte : codeToByte xs
codeToByte (Lstore byte:xs) = 0x37 : byte : codeToByte xs
codeToByte (Fstore byte:xs) = 0x38 : byte : codeToByte xs
codeToByte (Dstore byte:xs) = 0x39 : byte : codeToByte xs
codeToByte (Astore byte:xs) = 0x3a : byte : codeToByte xs
codeToByte (Istore0:xs) = 0x3b : codeToByte xs
codeToByte (Istore1:xs) = 0x3c : codeToByte xs
codeToByte (Istore2:xs) = 0x3d : codeToByte xs
codeToByte (Istore3:xs) = 0x3e : codeToByte xs
codeToByte (Lstore0:xs) = 0x3f : codeToByte xs
codeToByte (Lstore1:xs) = 0x40 : codeToByte xs
codeToByte (Lstore2:xs) = 0x41 : codeToByte xs
codeToByte (Lstore3:xs) = 0x42 : codeToByte xs
codeToByte (Fstore0:xs) = 0x43 : codeToByte xs
codeToByte (Fstore1:xs) = 0x44 : codeToByte xs
codeToByte (Fstore2:xs) = 0x45 : codeToByte xs
codeToByte (Fstore3:xs) = 0x46 : codeToByte xs
codeToByte (Dstore0:xs) = 0x47 : codeToByte xs
codeToByte (Dstore1:xs) = 0x48 : codeToByte xs
codeToByte (Dstore2:xs) = 0x49 : codeToByte xs
codeToByte (Dstore3:xs) = 0x4a : codeToByte xs
codeToByte (Astore0:xs) = 0x4b : codeToByte xs
codeToByte (Astore1:xs) = 0x4c : codeToByte xs
codeToByte (Astore2:xs) = 0x4d : codeToByte xs
codeToByte (Astore3:xs) = 0x4e : codeToByte xs
codeToByte (Iastore:xs) = 0x4f : codeToByte xs
codeToByte (Lastore:xs) = 0x50 : codeToByte xs
codeToByte (Fastore:xs) = 0x51 : codeToByte xs
codeToByte (Dastore:xs) = 0x52 : codeToByte xs
codeToByte (Aastore:xs) = 0x53 : codeToByte xs
codeToByte (Bastore:xs) = 0x54 : codeToByte xs
codeToByte (Castore:xs) = 0x55 : codeToByte xs
codeToByte (Sastore:xs) = 0x56 : codeToByte xs
codeToByte (Pop:xs) = 0x57 : codeToByte xs
codeToByte (Pop2:xs) = 0x58 : codeToByte xs
codeToByte (Dup:xs) = 0x59 : codeToByte xs
codeToByte (DupX1:xs) = 0x5a : codeToByte xs
codeToByte (DupX2:xs) = 0x5b : codeToByte xs
codeToByte (Dup2:xs) = 0x5c : codeToByte xs
codeToByte (Dup2X1:xs) = 0x5d : codeToByte xs
codeToByte (Dup2X2:xs) = 0x5e : codeToByte xs
codeToByte (Swap:xs) = 0x5f : codeToByte xs
codeToByte (Iadd:xs) = 0x60 : codeToByte xs
codeToByte (Ladd:xs) = 0x61 : codeToByte xs
codeToByte (Fadd:xs) = 0x62 : codeToByte xs
codeToByte (Dadd:xs) = 0x63 : codeToByte xs
codeToByte (Isub:xs) = 0x64 : codeToByte xs
codeToByte (Lsub:xs) = 0x65 : codeToByte xs
codeToByte (Fsub:xs) = 0x66 : codeToByte xs
codeToByte (Dsub:xs) = 0x67 : codeToByte xs
codeToByte (Imul:xs) = 0x68 : codeToByte xs
codeToByte (Lmul:xs) = 0x69 : codeToByte xs
codeToByte (Fmul:xs) = 0x6a : codeToByte xs
codeToByte (Dmul:xs) = 0x6b : codeToByte xs
codeToByte (Idiv:xs) = 0x6c : codeToByte xs
codeToByte (Ldiv:xs) = 0x6d : codeToByte xs
codeToByte (Fdiv:xs) = 0x6e : codeToByte xs
codeToByte (Ddiv:xs) = 0x6f : codeToByte xs
codeToByte (Irem:xs) = 0x70 : codeToByte xs
codeToByte (Lrem:xs) = 0x71 : codeToByte xs
codeToByte (Frem:xs) = 0x72 : codeToByte xs
codeToByte (Drem:xs) = 0x73 : codeToByte xs
codeToByte (Ineg:xs) = 0x74 : codeToByte xs
codeToByte (Lneg:xs) = 0x75 : codeToByte xs
codeToByte (Fneg:xs) = 0x76 : codeToByte xs
codeToByte (Dneg:xs) = 0x77 : codeToByte xs
codeToByte (Ishl:xs) = 0x78 : codeToByte xs
codeToByte (Lshl:xs) = 0x79 : codeToByte xs
codeToByte (Ishr:xs) = 0x7a : codeToByte xs
codeToByte (Lshr:xs) = 0x7b : codeToByte xs
codeToByte (Iushr:xs) = 0x7c : codeToByte xs
codeToByte (Lushr:xs) = 0x7d : codeToByte xs
codeToByte (Iand:xs) = 0x7e : codeToByte xs
codeToByte (Land:xs) = 0x7f : codeToByte xs
codeToByte (Ior:xs) = 0x80 : codeToByte xs
codeToByte (Lor:xs) = 0x81 : codeToByte xs
codeToByte (Ixor:xs) = 0x82 : codeToByte xs
codeToByte (Lxor:xs) = 0x83 : codeToByte xs
codeToByte (Iinc byte1 byte2:xs) = 0x84 : byte1 : byte2 : codeToByte xs
codeToByte (I2l:xs) = 0x85 : codeToByte xs
codeToByte (I2f:xs) = 0x86 : codeToByte xs
codeToByte (I2d:xs) = 0x87 : codeToByte xs
codeToByte (L2i:xs) = 0x88 : codeToByte xs
codeToByte (L2f:xs) = 0x89 : codeToByte xs
codeToByte (L2d:xs) = 0x8a : codeToByte xs
codeToByte (F2i:xs) = 0x8b : codeToByte xs
codeToByte (F2l:xs) = 0x8c : codeToByte xs
codeToByte (F2d:xs) = 0x8d : codeToByte xs
codeToByte (D2i:xs) = 0x8e : codeToByte xs
codeToByte (D2l:xs) = 0x8f : codeToByte xs
codeToByte (D2f:xs) = 0x90 : codeToByte xs
codeToByte (I2b:xs) = 0x91 : codeToByte xs
codeToByte (I2c:xs) = 0x92 : codeToByte xs
codeToByte (I2s:xs) = 0x93 : codeToByte xs
codeToByte (Lcmp:xs) = 0x94 : codeToByte xs
codeToByte (Fcmpl:xs) = 0x95 : codeToByte xs
codeToByte (Fcmpg:xs) = 0x96 : codeToByte xs
codeToByte (Dcmpl:xs) = 0x97 : codeToByte xs
codeToByte (Dcmpg:xs) = 0x98 : codeToByte xs
codeToByte (Ifeq byte1 byte2:xs) = 0x99 : byte1 : byte2 : codeToByte xs
codeToByte (Ifne byte1 byte2:xs) = 0x9a : byte1 : byte2 : codeToByte xs
codeToByte (Iflt byte1 byte2:xs) = 0x9b : byte1 : byte2 : codeToByte xs
codeToByte (Ifge byte1 byte2:xs) = 0x9c : byte1 : byte2 : codeToByte xs
codeToByte (Ifgt byte1 byte2:xs) = 0x9d : byte1 : byte2 : codeToByte xs
codeToByte (Ifle byte1 byte2:xs) = 0x9e : byte1 : byte2 : codeToByte xs
codeToByte (IfIcmpeq byte1 byte2:xs) = 0x9f : byte1 : byte2 : codeToByte xs
codeToByte (IfIcmpne byte1 byte2:xs) = 0xa0 : byte1 : byte2 : codeToByte xs
codeToByte (IfIcmplt byte1 byte2:xs) = 0xa1 : byte1 : byte2 : codeToByte xs
codeToByte (IfIcmpge byte1 byte2:xs) = 0xa2 : byte1 : byte2 : codeToByte xs
codeToByte (IfIcmpgt byte1 byte2:xs) = 0xa3 : byte1 : byte2 : codeToByte xs
codeToByte (IfIcmple byte1 byte2:xs) = 0xa4 : byte1 : byte2 : codeToByte xs
codeToByte (IfAcmpeq byte1 byte2:xs) = 0xa5 : byte1 : byte2 : codeToByte xs
codeToByte (IfAcmpne byte1 byte2:xs) = 0xa6 : byte1 : byte2 : codeToByte xs
codeToByte (Goto byte1 byte2:xs) = 0xa7 : byte1 : byte2 : codeToByte xs
codeToByte (Jsr byte1 byte2:xs) = 0xa8 : byte1 : byte2 : codeToByte xs
codeToByte (Ret byte:xs) = 0xa9 : byte : codeToByte xs
codeToByte (Tableswitch bs1 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 bs2:xs)
  = bs1 ++ (0xaa:b1:b2:b3:b4:b5:b6:b7:b8:b9:b10:b11:b12: bs2 ++ codeToByte xs)
codeToByte (Lookupswitch bs1 b1 b2 b3 b4 b5 b6 b7 b8 bs2:xs)
  = bs1 ++ (0xab:b1:b2:b3:b4:b5:b6:b7:b8:concatMap pair8ToList bs2 ++ codeToByte xs)
     where
       pair8ToList (a,b,c,d,e,f,g,h) = [a,b,c,d,e,f,g,h]
codeToByte (Ireturn:xs) = 0xac : codeToByte xs
codeToByte (Lreturn:xs) = 0xad : codeToByte xs
codeToByte (Freturn:xs) = 0xae : codeToByte xs
codeToByte (Dreturn:xs) = 0xaf : codeToByte xs
codeToByte (Areturn:xs) = 0xb0 : codeToByte xs
codeToByte (Return:xs) = 0xb1 : codeToByte xs
codeToByte (Getstatic byte1 byte2:xs) = 0xb2 : byte1 : byte2 : codeToByte xs
codeToByte (Putstatic byte1 byte2:xs) = 0xb3 : byte1 : byte2 : codeToByte xs
codeToByte (Getfield byte1 byte2:xs) = 0xb4 : byte1 : byte2 : codeToByte xs
codeToByte (Putfield byte1 byte2:xs) = 0xb5 : byte1 : byte2 : codeToByte xs
codeToByte (Invokevirtual byte1 byte2:xs) = 0xb6 : byte1 : byte2 : codeToByte xs
codeToByte (Invokespecial byte1 byte2:xs) = 0xb7 : byte1 : byte2 : codeToByte xs
codeToByte (Invokestatic byte1 byte2:xs) = 0xb8 : byte1 : byte2 : codeToByte xs
codeToByte (Invokeinterface idx1 idx2 count:xs)
  = 0xb9 : idx1 : idx2 : count : 0 : codeToByte xs
codeToByte (Invokedynamic idx1 idx2:xs) = 0xba:idx1:idx2:0:0:codeToByte xs
codeToByte (New byte1 byte2:xs) = 0xbb : byte1 : byte2 : codeToByte xs
codeToByte (Newarray byte:xs) = 0xbc : byte : codeToByte xs
codeToByte (Anewarray byte1 byte2:xs) = 0xbd : byte1 : byte2 : codeToByte xs
codeToByte (Arraylength:xs) = 0xbe : codeToByte xs
codeToByte (Athrow:xs) = 0xbf : codeToByte xs
codeToByte (Checkcast byte1 byte2:xs) = 0xc0 : byte1 : byte2 : codeToByte xs
codeToByte (Instanceof byte1 byte2:xs) = 0xc1 : byte1 : byte2 : codeToByte xs
codeToByte (Monitorenter:xs) = 0xc2 : codeToByte xs
codeToByte (Monitorexit:xs) = 0xc3 : codeToByte xs
codeToByte (Wide op b1 b2 Nothing Nothing:xs)
  = 0xc4:codeToByte [op] ++ [b1,b2]++ codeToByte xs
codeToByte (Wide op b1 b2 (Just b3) (Just b4):xs)
  = 0xc4:codeToByte [op] ++ [b1,b2,b3,b4]++ codeToByte xs
codeToByte (Multianewarray b1 b2 bs:xs) = 0xc5:b1:b2:(bs ++ codeToByte xs)
codeToByte (Ifnull byte1 byte2:xs) = 0xc6 : byte1 : byte2 : codeToByte xs
codeToByte (Ifnonnull byte1 byte2:xs) = 0xc7 : byte1 : byte2 : codeToByte xs
codeToByte (GotoW b1 b2 b3 b4:xs) = 0xc8:b1:b2:b3:b4:codeToByte xs
codeToByte (JsrW b1 b2 b3 b4:xs) = 0xc9:b1:b2:b3:b4:codeToByte xs
codeTOInt (Breakpoint:xs) = 0xca : codeToByte xs
codeTOInt (Impdep1:xs) = 0xfe : codeToByte xs
codeTOInt (Impdep2:xs) = 0xff : codeToByte xs


-- helper


-- | split a unsigned 16 bits int in two signed 8 bits int
split16Byte :: (Show n,Bits n,Integral n) => n -- ^ 16 Byte
                                          -> (Byte -- ^ upper 8 byte
                                             ,Byte) -- ^ lower 8 byte
split16Byte i = (read . show $ div i (2^8),read . show $ mod i (2^8))


-- | split a unsigned 32 bits int in 4 signed 8 bits int
split32Byte :: (Show n,Bits n,Integral n) => n -- ^ 32 Byte
                                          -> (Byte -- ^ upper 8 byte
                                             ,Byte -- ^ middle 8 byte
                                             ,Byte -- ^ middle 8 byte
                                             ,Byte) -- ^ lower 8 byte
split32Byte i = (read . show $ div i (2^24)
                ,read . show $ div (mod i (2^24)) (2^16)
                ,read . show $ div (mod (mod i (2^24)) (2^16)) (2^8)
                ,read . show $ mod (mod (mod i (2^24)) (2^16)) (2^8))

visToFlag :: Visibility -> Int
visToFlag Public = 1
visToFlag Private = 2
-- visToFlag Protected = 4

typeToDescriptor :: Type -> String
typeToDescriptor "boolean" = "Z"
typeToDescriptor "char" = "C"
typeToDescriptor "int" = "I"
typeToDescriptor "" = "V" -- constructors have type void in class files
-- TODO method with arguments
typeToDescriptor "void" = "V"
typeToDescriptor object = "L" ++ object ++ ";"

iconst :: Int -> Assembler
iconst 0 = Iconst0
iconst 1 = Iconst1
iconst 2 = Iconst2
iconst 3 = Iconst3
iconst 4 = Iconst4
iconst 5 = Iconst5
iconst n = Bipush . read . show $ n

aload :: Int -> Assembler
aload 0 = Aload0
aload 1 = Aload1
aload 2 = Aload2
aload 3 = Aload3
aload n = Aload . read . show $ n

dload :: Int -> Assembler
dload 0 = Dload0
dload 1 = Dload1
dload 2 = Dload2
dload 3 = Dload3
dload n = Dload  . read . show $ n

fload :: Int -> Assembler
fload 0 = Fload0
fload 1 = Fload1
fload 2 = Fload2
fload 3 = Fload3
fload n = Fload . read . show $ n

iload :: Int -> Assembler
iload 0 = Iload0
iload 1 = Iload1
iload 2 = Iload2
iload 3 = Iload3
iload n = Iload . read . show $ n

lload :: Int -> Assembler
lload 0 = Lload0
lload 1 = Lload1
lload 2 = Lload2
lload 3 = Lload3
lload n = Lload . read . show $ n

astore :: Int -> Assembler
astore 0 = Astore0
astore 1 = Astore1
astore 2 = Astore2
astore 3 = Astore3
astore n = Astore . read . show $ n

dstore :: Int -> Assembler
dstore 0 = Dstore0
dstore 1 = Dstore1
dstore 2 = Dstore2
dstore 3 = Dstore3
dstore n = Dstore . read . show $ n

fstore :: Int -> Assembler
fstore 0 = Fstore0
fstore 1 = Fstore1
fstore 2 = Fstore2
fstore 3 = Fstore3
fstore n = Fstore . read . show $ n

istore :: Int -> Assembler
istore 0 = Istore0
istore 1 = Istore1
istore 2 = Istore2
istore 3 = Istore3
istore n = Istore . read . show $ n

lstore :: Int -> Assembler
lstore 0 = Lstore0
lstore 1 = Lstore1
lstore 2 = Lstore2
lstore 3 = Lstore3
lstore n = Lstore . read . show $ n
