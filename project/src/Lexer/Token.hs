module Lexer.Token where

import           Data.Bool
import           Data.Char
import           Data.Int
import           Data.String

data Token
     -- Arithmentics
     = ADD
     | SUBTRACT
     | MULTIPLY
     | DIVIDE
     | MODULO
     | INCREMENT
     | DECREMENT
     -- Logical
     | NOT
     | AND
     | OR
     | EQUAL
     | NOT_EQUAL
     | LESSER
     | GREATER
     | LESSER_EQUAL
     | GREATER_EQUAL
     -- Bitwise
     | BITWISE_AND
     | BITWISE_OR
     | BITWISE_XOR
     | SHIFTLEFT
     | SHIFTRIGHT
     | UNSIGNED_SHIFTRIGHT
     -- Punctuators
     | LEFT_PARANTHESES
     | RIGHT_PARANTHESES
     -- | LEFT_BRACKET
     -- | RIGHT_BRACKET
     | LEFT_BRACE
     | RIGHT_BRACE
     | DOT
     | COMMA
     | COLON
     | SEMICOLON
     -- Assignment
     | ASSIGN
     | ADD_ASSIGN
     | SUBTRACT_ASSIGN
     | MULTIPLY_ASSIGN
     | DIVIDE_ASSIGN
     | MODULO_ASSIGN
     | AND_ASSIGN
     | OR_ASSIGN
     | XOR_ASSIGN
     | SHIFTLEFT_ASSIGN
     | SHIFTRIGHT_ASSIGN
     | UNSIGNED_SHIFTRIGHT_ASSIGN
     -- Types
     | BOOLEAN
     | CHARACTER
     | INTEGER
     | VOID
     -- Loops
     | FOR
     | WHILE
     | DO
     | BREAK
     | CONTINUE
     -- Conditional
     | IF
     | ELSE
     | SWITCH
     | CASE
     | FINALLY
     | QUESTIONMARK
     -- Class
     | CLASS
     | NEW
     | PRIVATE
     | PUBLIC
     -- | PROTECTED
     | STATIC
     | THIS
     -- Method
     | RETURN
     -- Literals
     | BOOLEAN_LITERAL Bool
     | CHARACTER_LITERAL Char
     | INTEGER_LITERAL Int32
     | IDENTIFIER String
     | JNULL
     -- Other
     | INSTANCEOF
     | FINAL
     deriving(Eq,Show)



