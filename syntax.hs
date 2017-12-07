data Token
     = ABSTRACT 
     | BOOLEAN 
     | BREAK 
     | CASE 
     | CATCH 
     | CHAR  
     | CLASS
     | CONTINUE 
     | DEFAULT 
     | DO 
     | ELSE 
     | EXTENDS 
     | FINALLY 
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
     | SUPER 
     | SWITCH 
     | THIS 
     | THROW 
     | THROWS 
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
     | SHARP
     | ARROW
     deriving(Eq,Show)

data FieldDecl = FieldDecl(Type, String)
data MethodDecl = Method(Type, String,[Type, String], Stmt)
data Class = Class(Type, [FieldDecl], [MethodDecl])

data Expr = This
    | Super
    | LocalOrFieldVar(String)
    | InstVar(Expr, String)
    | Unary(String, Expr)
    | Binary(String, Expr, Expr)
    | Integer(Integer)
    | Bool(Bool)
    | Char(Char)
    | String(String)
    | Jnull
    | StmtExprExpr(StmtExpr)

data StmtExpr = Assign(Expr, Expr)
    | New(Type, [Expr])
    | MethodCall(Expr, String, [Expr])

data Stmt = Block([Stmt])
    | Return( Expr )
    | While( Expr , Stmt )
    | LocalVarDecl( Type, String )
    | If( Expr, Stmt , Maybe Stmt )
    | StmtExprStmt(StmtExpr)

data StmtExpr = Assign(Expr, Expr)
    | New(Type, [Expr])
    | MethodCall(Expr, String, [Expr])

data Token = BOOLEAN
    | BREAK
    | CASE
    | CHAR
    | CLASS
    | IDENTIFIER String
    | INTLITERAL Int

