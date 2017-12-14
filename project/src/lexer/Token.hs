module Lexer.Token where

data Token
     = BOOLEAN 
     | BREAK 
     | CASE 
     | CHAR  
     | CLASS
     | CONTINUE 
     | DO 
     | ELSE 
     | FOR 
     | IF 
     | INSTANCEOF 
     | INT
     | NEW 
     | PRIVATE 
     | PROTECTED 
     | PUBLIC 
     | RETURN 
     | STATIC 
     | SWITCH 
     | THIS 
     | VOID 
     | WHILE 
     | INTLITERAL Integer
     | BOOLLITERAL Bool
     | JNULL 
     | CHARLITERAL Char
     | STRINGLITERAL String
     | IDENTIFIER String
     | EQUAL 
     | LESSEQUAL 
     | GREATEREQUAL 
     | NOTEQUAL 
     | INCREMENT 
     | DECREMENT 
     | SHIFTLEFT 
     | SHIFTRIGHT 
     | UNSIGNEDSHIFTRIGHT 
     | SIGNEDSHIFTRIGHT 
     | PLUSEQUAL 
     | MINUSEQUAL 
     | TIMESEQUAL 
     | DIVIDEEQUAL 
     | ANDEQUAL 
     | OREQUAL 
     | XOREQUAL 
     | MODULOEQUAL 
     | SHIFTLEFTEQUAL 
     | SIGNEDSHIFTRIGHTEQUAL 
     | UNSIGNEDSHIFTRIGHTEQUAL 
     | LBRACE 
     | RBRACE 
     | LBRACKET 
     | RBRACKET 
     | LSQBRACKET 
     | RSQBRACKET 
     | SEMICOLON 
     | DOT 
     | ASSIGN 
     | LESS 
     | GREATER 
     | EXCLMARK 
     | TILDE 
     | QUESMARK 
     | COLON 
     | PLUS 
     | MINUS 
     | MUL 
     | DIV 
     | MOD 
     | AND 
     | OR 
     | XOR 
     | SHARP
     | ARROW
     | COMMA
     deriving(Eq,Show)
