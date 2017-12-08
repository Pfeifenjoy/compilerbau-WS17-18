module Token where

data Token
    = BOOLEAN
    | BYTE
    | CHAR
    | INTEGER
    | LONG
    | FLOAT
    | DOUBLE
    | ElementaryType
    | BREAK 
    | CASE 
    | CATCH 
    | CLASS
    | CONTINUE 
    | DEFAULT 
    | DO 
    | ELSE 
    | FOR 
    | IF 
    | INSTANCEOF 
    | NEW 
    | PRIVATE 
    | PROTECTED 
    | PUBLIC 
    | RETURN 
    | STATIC 
    | SWITCH 
    | THIS 
    | TRY 
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
    | LOGICALOR 
    | LOGICALAND 
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
    deriving(Eq,Show)

