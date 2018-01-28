module Codegen.EvalCode where

import ABSTree
import Data.Char(ord)
import Data.Bits

evalInt ::  Expr -> Int
evalInt (BooleanLiteral True)  = 1
evalInt (BooleanLiteral False) = 0
evalInt (CharLiteral char)     = ord char
evalInt (IntegerLiteral int)   = fromIntegral int
evalInt (Binary "&&" expr1 expr2) = evalInt expr1 .&. evalInt expr2
evalInt (Binary "||" expr1 expr2) = evalInt expr1 .|. evalInt expr2
evalInt (Binary "+" expr1 expr2) = evalInt expr1 + evalInt expr2
evalInt (Binary "-" expr1 expr2) = evalInt expr1 - evalInt expr2
evalInt (Binary "*" expr1 expr2) = evalInt expr1 * evalInt expr2
