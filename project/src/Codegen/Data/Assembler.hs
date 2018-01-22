{-|
This module contains a abstract assembler and function to convert it to
int, which is later translated in to byte code
-}
module Codegen.Data.Assembler where

import ABSTree(Visibility(..),Type) 
import Data.Bits

type Byte = Int 
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
  deriving(Show)

type Code = [Assembler]

codeToInt :: Code                       -> [Int]
codeToInt []       = []
codeToInt (Nop:xs) = 0x00 : codeToInt xs
codeToInt (AconstNull:xs) = 0x01 : codeToInt xs
codeToInt (IconstM1:xs) = 0x02 : codeToInt xs
codeToInt (Iconst0:xs) = 0x03 : codeToInt xs
codeToInt (Iconst1:xs) = 0x04 : codeToInt xs
codeToInt (Iconst2:xs) = 0x05 : codeToInt xs
codeToInt (Iconst3:xs) = 0x06 : codeToInt xs
codeToInt (Iconst4:xs) = 0x07 : codeToInt xs
codeToInt (Iconst5:xs) = 0x08 : codeToInt xs
codeToInt (Lconst0:xs) = 0x09 : codeToInt xs
codeToInt (Lconst1:xs) = 0x0a : codeToInt xs
codeToInt (Fconst0:xs) = 0x0b : codeToInt xs
codeToInt (Fconst1:xs) = 0x0c : codeToInt xs
codeToInt (Fconst2:xs) = 0x0d : codeToInt xs
codeToInt (Dconst0:xs) = 0x0e : codeToInt xs
codeToInt (Dconst1:xs) = 0x0f : codeToInt xs
codeToInt (Bipush byte:xs) = 0x10 : byte : codeToInt xs
codeToInt (Sipush byte1 byte2:xs) = 0x11 : byte1 : byte2 : codeToInt xs
codeToInt (Ldc byte:xs) = 0x12 : byte : codeToInt xs
codeToInt (LdcW byte1 byte2:xs) = 0x13 : byte1 : byte2 : codeToInt xs
codeToInt (Ldc2W byte1 byte2:xs) = 0x14 : byte1 : byte2 : codeToInt xs
codeToInt (Iload byte:xs) = 0x15 : byte : codeToInt xs
codeToInt (Lload byte:xs) = 0x16 : byte : codeToInt xs
codeToInt (Fload byte:xs) = 0x17 : byte : codeToInt xs
codeToInt (Dload byte:xs) = 0x18 : byte : codeToInt xs
codeToInt (Aload byte:xs) = 0x19 : byte : codeToInt xs
codeToInt (Iload0:xs) = 0x1a : codeToInt xs
codeToInt (Iload1:xs) = 0x1b : codeToInt xs
codeToInt (Iload2:xs) = 0x1c : codeToInt xs
codeToInt (Iload3:xs) = 0x1d : codeToInt xs
codeToInt (Lload0:xs) = 0x1e : codeToInt xs
codeToInt (Lload1:xs) = 0x1f : codeToInt xs
codeToInt (Lload2:xs) = 0x20 : codeToInt xs
codeToInt (Lload3:xs) = 0x21 : codeToInt xs
codeToInt (Fload0:xs) = 0x22 : codeToInt xs
codeToInt (Fload1:xs) = 0x23 : codeToInt xs
codeToInt (Fload2:xs) = 0x24 : codeToInt xs
codeToInt (Fload3:xs) = 0x25 : codeToInt xs
codeToInt (Dload0:xs) = 0x26 : codeToInt xs
codeToInt (Dload1:xs) = 0x27 : codeToInt xs
codeToInt (Dload2:xs) = 0x28 : codeToInt xs
codeToInt (Dload3:xs) = 0x29 : codeToInt xs
codeToInt (Aload0:xs) = 0x2a : codeToInt xs
codeToInt (Aload1:xs) = 0x2b : codeToInt xs
codeToInt (Aload2:xs) = 0x2c : codeToInt xs
codeToInt (Aload3:xs) = 0x2d : codeToInt xs
codeToInt (Iaload:xs) = 0x2e : codeToInt xs
codeToInt (Laload:xs) = 0x2f : codeToInt xs
codeToInt (Faload:xs) = 0x30 : codeToInt xs
codeToInt (Daload:xs) = 0x31 : codeToInt xs
codeToInt (Aaload:xs) = 0x32 : codeToInt xs
codeToInt (Baload:xs) = 0x33 : codeToInt xs
codeToInt (Caload:xs) = 0x34 : codeToInt xs
codeToInt (Saload:xs) = 0x35 : codeToInt xs
codeToInt (Istore byte:xs) = 0x36 : byte : codeToInt xs
codeToInt (Lstore byte:xs) = 0x37 : byte : codeToInt xs
codeToInt (Fstore byte:xs) = 0x38 : byte : codeToInt xs
codeToInt (Dstore byte:xs) = 0x39 : byte : codeToInt xs
codeToInt (Astore byte:xs) = 0x3a : byte : codeToInt xs
codeToInt (Istore0:xs) = 0x3b : codeToInt xs
codeToInt (Istore1:xs) = 0x3c : codeToInt xs
codeToInt (Istore2:xs) = 0x3d : codeToInt xs
codeToInt (Istore3:xs) = 0x3e : codeToInt xs
codeToInt (Lstore0:xs) = 0x3f : codeToInt xs
codeToInt (Lstore1:xs) = 0x40 : codeToInt xs
codeToInt (Lstore2:xs) = 0x41 : codeToInt xs
codeToInt (Lstore3:xs) = 0x42 : codeToInt xs
codeToInt (Fstore0:xs) = 0x43 : codeToInt xs
codeToInt (Fstore1:xs) = 0x44 : codeToInt xs
codeToInt (Fstore2:xs) = 0x45 : codeToInt xs
codeToInt (Fstore3:xs) = 0x46 : codeToInt xs
codeToInt (Dstore0:xs) = 0x47 : codeToInt xs
codeToInt (Dstore1:xs) = 0x48 : codeToInt xs
codeToInt (Dstore2:xs) = 0x49 : codeToInt xs
codeToInt (Dstore3:xs) = 0x4a : codeToInt xs
codeToInt (Astore0:xs) = 0x4b : codeToInt xs
codeToInt (Astore1:xs) = 0x4c : codeToInt xs
codeToInt (Astore2:xs) = 0x4d : codeToInt xs
codeToInt (Astore3:xs) = 0x4e : codeToInt xs
codeToInt (Iastore:xs) = 0x4f : codeToInt xs
codeToInt (Lastore:xs) = 0x50 : codeToInt xs
codeToInt (Fastore:xs) = 0x51 : codeToInt xs
codeToInt (Dastore:xs) = 0x52 : codeToInt xs
codeToInt (Aastore:xs) = 0x53 : codeToInt xs
codeToInt (Bastore:xs) = 0x54 : codeToInt xs
codeToInt (Castore:xs) = 0x55 : codeToInt xs
codeToInt (Sastore:xs) = 0x56 : codeToInt xs
codeToInt (Pop:xs) = 0x57 : codeToInt xs
codeToInt (Pop2:xs) = 0x58 : codeToInt xs
codeToInt (Dup:xs) = 0x59 : codeToInt xs
codeToInt (DupX1:xs) = 0x5a : codeToInt xs
codeToInt (DupX2:xs) = 0x5b : codeToInt xs
codeToInt (Dup2:xs) = 0x5c : codeToInt xs
codeToInt (Dup2X1:xs) = 0x5d : codeToInt xs
codeToInt (Dup2X2:xs) = 0x5e : codeToInt xs
codeToInt (Swap:xs) = 0x5f : codeToInt xs
codeToInt (Iadd:xs) = 0x60 : codeToInt xs
codeToInt (Ladd:xs) = 0x61 : codeToInt xs
codeToInt (Fadd:xs) = 0x62 : codeToInt xs
codeToInt (Dadd:xs) = 0x63 : codeToInt xs
codeToInt (Isub:xs) = 0x64 : codeToInt xs
codeToInt (Lsub:xs) = 0x65 : codeToInt xs
codeToInt (Fsub:xs) = 0x66 : codeToInt xs
codeToInt (Dsub:xs) = 0x67 : codeToInt xs
codeToInt (Imul:xs) = 0x68 : codeToInt xs
codeToInt (Lmul:xs) = 0x69 : codeToInt xs
codeToInt (Fmul:xs) = 0x6a : codeToInt xs
codeToInt (Dmul:xs) = 0x6b : codeToInt xs
codeToInt (Idiv:xs) = 0x6c : codeToInt xs
codeToInt (Ldiv:xs) = 0x6d : codeToInt xs
codeToInt (Fdiv:xs) = 0x6e : codeToInt xs
codeToInt (Ddiv:xs) = 0x6f : codeToInt xs
codeToInt (Irem:xs) = 0x70 : codeToInt xs
codeToInt (Lrem:xs) = 0x71 : codeToInt xs
codeToInt (Frem:xs) = 0x72 : codeToInt xs
codeToInt (Drem:xs) = 0x73 : codeToInt xs
codeToInt (Ineg:xs) = 0x74 : codeToInt xs
codeToInt (Lneg:xs) = 0x75 : codeToInt xs
codeToInt (Fneg:xs) = 0x76 : codeToInt xs
codeToInt (Dneg:xs) = 0x77 : codeToInt xs
codeToInt (Ishl:xs) = 0x78 : codeToInt xs
codeToInt (Lshl:xs) = 0x79 : codeToInt xs
codeToInt (Ishr:xs) = 0x7a : codeToInt xs
codeToInt (Lshr:xs) = 0x7b : codeToInt xs
codeToInt (Iushr:xs) = 0x7c : codeToInt xs
codeToInt (Lushr:xs) = 0x7d : codeToInt xs
codeToInt (Iand:xs) = 0x7e : codeToInt xs
codeToInt (Land:xs) = 0x7f : codeToInt xs
codeToInt (Ior:xs) = 0x80 : codeToInt xs
codeToInt (Lor:xs) = 0x81 : codeToInt xs
codeToInt (Ixor:xs) = 0x82 : codeToInt xs
codeToInt (Lxor:xs) = 0x83 : codeToInt xs
codeToInt (Iinc byte1 byte2:xs) = 0x84 : byte1 : byte2 : codeToInt xs
codeToInt (I2l:xs) = 0x85 : codeToInt xs
codeToInt (I2f:xs) = 0x86 : codeToInt xs
codeToInt (I2d:xs) = 0x87 : codeToInt xs
codeToInt (L2i:xs) = 0x88 : codeToInt xs
codeToInt (L2f:xs) = 0x89 : codeToInt xs
codeToInt (L2d:xs) = 0x8a : codeToInt xs
codeToInt (F2i:xs) = 0x8b : codeToInt xs
codeToInt (F2l:xs) = 0x8c : codeToInt xs
codeToInt (F2d:xs) = 0x8d : codeToInt xs
codeToInt (D2i:xs) = 0x8e : codeToInt xs
codeToInt (D2l:xs) = 0x8f : codeToInt xs
codeToInt (D2f:xs) = 0x90 : codeToInt xs
codeToInt (I2b:xs) = 0x91 : codeToInt xs
codeToInt (I2c:xs) = 0x92 : codeToInt xs
codeToInt (I2s:xs) = 0x93 : codeToInt xs
codeToInt (Lcmp:xs) = 0x94 : codeToInt xs
codeToInt (Fcmpl:xs) = 0x95 : codeToInt xs
codeToInt (Fcmpg:xs) = 0x96 : codeToInt xs
codeToInt (Dcmpl:xs) = 0x97 : codeToInt xs
codeToInt (Dcmpg:xs) = 0x98 : codeToInt xs
codeToInt (Ifeq byte1 byte2:xs) = 0x99 : byte1 : byte2 : codeToInt xs
codeToInt (Ifne byte1 byte2:xs) = 0x9a : byte1 : byte2 : codeToInt xs
codeToInt (Iflt byte1 byte2:xs) = 0x9b : byte1 : byte2 : codeToInt xs
codeToInt (Ifge byte1 byte2:xs) = 0x9c : byte1 : byte2 : codeToInt xs
codeToInt (Ifgt byte1 byte2:xs) = 0x9d : byte1 : byte2 : codeToInt xs
codeToInt (Ifle byte1 byte2:xs) = 0x9e : byte1 : byte2 : codeToInt xs
codeToInt (IfIcmpeq byte1 byte2:xs) = 0x9f : byte1 : byte2 : codeToInt xs
codeToInt (IfIcmpne byte1 byte2:xs) = 0xa0 : byte1 : byte2 : codeToInt xs
codeToInt (IfIcmplt byte1 byte2:xs) = 0xa1 : byte1 : byte2 : codeToInt xs
codeToInt (IfIcmpge byte1 byte2:xs) = 0xa2 : byte1 : byte2 : codeToInt xs
codeToInt (IfIcmpgt byte1 byte2:xs) = 0xa3 : byte1 : byte2 : codeToInt xs
codeToInt (IfIcmple byte1 byte2:xs) = 0xa4 : byte1 : byte2 : codeToInt xs
codeToInt (IfAcmpeq byte1 byte2:xs) = 0xa5 : byte1 : byte2 : codeToInt xs
codeToInt (IfAcmpne byte1 byte2:xs) = 0xa6 : byte1 : byte2 : codeToInt xs
codeToInt (Goto byte1 byte2:xs) = 0xa7 : byte1 : byte2 : codeToInt xs
codeToInt (Jsr byte1 byte2:xs) = 0xa8 : byte1 : byte2 : codeToInt xs
codeToInt (Ret byte:xs) = 0xa9 : byte : codeToInt xs
codeToInt (Tableswitch bs1 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 bs2:xs) 
  = bs1 ++ (0xaa:b1:b2:b3:b4:b5:b6:b7:b8:b9:b10:b11:b12: bs2 ++ codeToInt xs)
codeToInt (Lookupswitch bs1 b1 b2 b3 b4 b5 b6 b7 b8 bs2:xs) 
  = bs1 ++ (0xab:b1:b2:b3:b4:b5:b6:b7:b8:concatMap pair8ToList bs2 ++ codeToInt xs)
     where
       pair8ToList (a,b,c,d,e,f,g,h) = [a,b,c,d,e,f,g,h]
codeToInt (Ireturn:xs) = 0xac : codeToInt xs
codeToInt (Lreturn:xs) = 0xad : codeToInt xs
codeToInt (Freturn:xs) = 0xae : codeToInt xs
codeToInt (Dreturn:xs) = 0xaf : codeToInt xs
codeToInt (Areturn:xs) = 0xb0 : codeToInt xs
codeToInt (Return:xs) = 0xb1 : codeToInt xs
codeToInt (Getstatic byte1 byte2:xs) = 0xb2 : byte1 : byte2 : codeToInt xs
codeToInt (Putstatic byte1 byte2:xs) = 0xb3 : byte1 : byte2 : codeToInt xs
codeToInt (Getfield byte1 byte2:xs) = 0xb4 : byte1 : byte2 : codeToInt xs
codeToInt (Putfield byte1 byte2:xs) = 0xb5 : byte1 : byte2 : codeToInt xs
codeToInt (Invokevirtual byte1 byte2:xs) = 0xb6 : byte1 : byte2 : codeToInt xs
codeToInt (Invokespecial byte1 byte2:xs) = 0xb7 : byte1 : byte2 : codeToInt xs
codeToInt (Invokestatic byte1 byte2:xs) = 0xb8 : byte1 : byte2 : codeToInt xs
codeToInt (Invokeinterface idx1 idx2 count:xs) 
  = 0xb9 : idx1 : idx2 : count : 0 : codeToInt xs
codeToInt (Invokedynamic idx1 idx2:xs) = 0xba:idx1:idx2:0:0:codeToInt xs
codeToInt (New byte1 byte2:xs) = 0xbb : byte1 : byte2 : codeToInt xs
codeToInt (Newarray byte:xs) = 0xbc : byte : codeToInt xs
codeToInt (Anewarray byte1 byte2:xs) = 0xbd : byte1 : byte2 : codeToInt xs
codeToInt (Arraylength:xs) = 0xbe : codeToInt xs
codeToInt (Athrow:xs) = 0xbf : codeToInt xs
codeToInt (Checkcast byte1 byte2:xs) = 0xc0 : byte1 : byte2 : codeToInt xs
codeToInt (Instanceof byte1 byte2:xs) = 0xc1 : byte1 : byte2 : codeToInt xs
codeToInt (Monitorenter:xs) = 0xc2 : codeToInt xs
codeToInt (Monitorexit:xs) = 0xc3 : codeToInt xs
codeToInt (Wide op b1 b2 Nothing Nothing:xs) 
  = 0xc4:codeToInt [op] ++ [b1,b2]++ codeToInt xs
codeToInt (Wide op b1 b2 (Just b3) (Just b4):xs) 
  = 0xc4:codeToInt [op] ++ [b1,b2,b3,b4]++ codeToInt xs
codeToInt (Multianewarray b1 b2 bs:xs) = 0xc5:b1:b2:(bs ++ codeToInt xs)
codeToInt (Ifnull byte1 byte2:xs) = 0xc6 : byte1 : byte2 : codeToInt xs
codeToInt (Ifnonnull byte1 byte2:xs) = 0xc7 : byte1 : byte2 : codeToInt xs
codeToInt (GotoW b1 b2 b3 b4:xs) = 0xc8:b1:b2:b3:b4:codeToInt xs
codeToInt (JsrW b1 b2 b3 b4:xs) = 0xc9:b1:b2:b3:b4:codeToInt xs
codeTOInt (Breakpoint:xs) = 0xca : codeToInt xs
codeTOInt (Impdep1:xs) = 0xfe : codeToInt xs
codeTOInt (Impdep2:xs) = 0xff : codeToInt xs


-- helper


-- | split a unsigned 16 bits int in two signed 8 bits int
split16Byte :: (Bits n,Integral n) => n -- ^ 16 Byte
                                   -> (n -- ^ upper 8 byte
                                      ,n) -- ^ lower 8 byte
split16Byte i = (div i (2^8),mod i (2^8))


-- TODO make sure that's correct
-- | makes the two complement of a 16 bits int
twoCompliment16 :: (Bits n,Num n) => n -> n
twoCompliment16 i = -(i .&. mask) + (i .&. complement mask)
  where mask = 2^(16-1)


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

iconst :: Indexbyte -> Assembler
iconst 0 = Iconst0
iconst 1 = Iconst1
iconst 2 = Iconst2
iconst 3 = Iconst3
iconst 4 = Iconst4
iconst 5 = Iconst5
iconst n = Bipush n

aload :: Indexbyte -> Assembler
aload 0 = Aload0
aload 1 = Aload1
aload 2 = Aload2
aload 3 = Aload3
aload n = Aload n

dload :: Indexbyte -> Assembler
dload 0 = Dload0
dload 1 = Dload1
dload 2 = Dload2
dload 3 = Dload3
dload n = Dload n

fload :: Indexbyte -> Assembler
fload 0 = Fload0
fload 1 = Fload1
fload 2 = Fload2
fload 3 = Fload3
fload n = Fload n

iload :: Indexbyte -> Assembler
iload 0 = Iload0
iload 1 = Iload1
iload 2 = Iload2
iload 3 = Iload3
iload n = Iload n

lload :: Indexbyte -> Assembler
lload 0 = Lload0
lload 1 = Lload1
lload 2 = Lload2
lload 3 = Lload3
lload n = Lload n

astore :: Indexbyte -> Assembler
astore 0 = Astore0
astore 1 = Astore1
astore 2 = Astore2
astore 3 = Astore3
astore n = Astore n

dstore :: Indexbyte -> Assembler
dstore 0 = Dstore0
dstore 1 = Dstore1
dstore 2 = Dstore2
dstore 3 = Dstore3
dstore n = Dstore n

fstore :: Indexbyte -> Assembler
fstore 0 = Fstore0
fstore 1 = Fstore1
fstore 2 = Fstore2
fstore 3 = Fstore3
fstore n = Fstore n

istore :: Indexbyte -> Assembler
istore 0 = Istore0
istore 1 = Istore1
istore 2 = Istore2
istore 3 = Istore3
istore n = Istore n

lstore :: Indexbyte -> Assembler
lstore 0 = Lstore0
lstore 1 = Lstore1
lstore 2 = Lstore2
lstore 3 = Lstore3
lstore n = Lstore n
