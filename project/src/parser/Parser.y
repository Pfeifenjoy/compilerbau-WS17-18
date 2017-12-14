{
module Parser  where
import Lexer
}

%name parse
%tokentype { Token }
%error { parseError }

%token
    BOOLEAN {BOOLEAN}
    BREAK  {BREAK}
    CASE  {CASE}
    CHAR   {CHAR}
    CLASS {CLASS}
    CONTINUE  {CONTINUE}
    DO  {DO}
    ELSE  {ELSE}
    FOR  {FOR}
    IF  {IF}
    INSTANCEOF  {INSTANCEOF}
    INT {INT}
    NEW {NEW}
    PRIVATE {PRIVATE}
    PROTECTED  {PROTECTED}
    PUBLIC  {PUBLIC}
    RETURN  {RETURN}
    STATIC  {STATIC}
    SWITCH  {SWITCH}
    THIS  {THIS}
    VOID  {VOID}
    WHILE  {WHILE}
    INTLITERAL {INTLITERAL $$}
    BOOLLITERAL {BOOLLITERAL $$}
    JNULL  {JNULL}
    CHARLITERAL {CHARLITERAL $$}
    STRINGLITERAL {STRINGLITERAL $$}
    IDENTIFIER {IDENTIFIER $$}
    EQUAL  {EQUAL}
    LESSEQUAL  {LESSEQUAL}
    GREATEREQUAL  {GREATEREQUAL}
    NOTEQUAL  {NOTEQUAL}
    LOGICALOR  {LOGICALOR}
    LOGICALAND  {LOGICALAND}
    INCREMENT  {INCREMENT}
    DECREMENT  {DECREMENT}
    SHIFTLEFT  {SHIFTLEFT}
    SHIFTRIGHT  {SHIFTRIGHT}
    UNSIGNEDSHIFTRIGHT  {UNSIGNEDSHIFTRIGHT}
    SIGNEDSHIFTRIGHT  {SIGNEDSHIFTRIGHT}
    PLUSEQUAL  {PLUSEQUAL}
    MINUSEQUAL  {MINUSEQUAL}
    TIMESEQUAL  {TIMESEQUAL}
    DIVIDEEQUAL  {DIVIDEEQUAL}
    ANDEQUAL  {ANDEQUAL}
    OREQUAL  {OREQUAL}
    XOREQUAL  {XOREQUAL}
    MODULOEQUAL  {MODULOEQUAL}
    SHIFTLEFTEQUAL  {SHIFTLEFTEQUAL}
    SIGNEDSHIFTRIGHTEQUAL  {SIGNEDSHIFTRIGHTEQUAL}
    UNSIGNEDSHIFTRIGHTEQUAL  {UNSIGNEDSHIFTRIGHTEQUAL}
    LBRACE {LBRACE}
    RBRACE {RBRACE}
    LBRACKET  {LBRACKET}
    RBRACKET  {RBRACKET}
    LSQBRACKET  {LSQBRACKET}
    RSQBRACKET  {RSQBRACKET}
    SEMICOLON  {SEMICOLON}
    DOT  {DOT}
    ASSIGN  {ASSIGN}
    LESS  {LESS}
    GREATER  {GREATER}
    EXCLMARK  {EXCLMARK}
    TILDE  {TILDE}
    QUESMARK  {QUESMARK}
    COLON  {COLON}
    PLUS  {PLUS}
    MINUS  {MINUS}
    MUL  {MUL}
    DIV  {DIV}
    MOD  {MOD}
    AND  {AND}
    OR  {OR}
    XOR  {XOR}
    SHARP {SHARP}
    ARROW {ARROW}
%%

Program :
        MainClass ClassDeclarationList { Program $1 $2 }

MainClass :
        CLASS IDENTIFIER LBRACKET PUBLIC STATIC VOID "main" LBRACE "String" "[" "]" IDENTIFIER RBRACE LBRACKET Statement RBRACKET RBRACKET { MClas $2 $12 $15}

ClassDeclarationList:
        ClassDeclaration {ClassDeclarationList $1 ClassEmpty}
        | ClassDeclaration ClassDeclarationList { ClassDeclarationList $1 $2 }
        | { ClassEmpty }

ClassDeclaration :
        CLASS IDENTIFIER LBRACKET VariableDeclarationList MethodDeclarationList RBRACKET { ClassDeclaration $2 VOID $4 $5}

MethodDeclarationList :
        MethodDeclaration { MethodDeclarationList $1 MethodEmpty }
        | MethodDeclaration MethodDeclarationList { MethodDeclarationList $1 $2 }
        | {MethodEmpty}

MethodDeclaration :
        PUBLIC Type IDENTIFIER LBRACE FormalList RBRACE LBRACKET VariableDeclarationList StatementList RETURN Expression SEMICOLON RBRACKET { MethodDeclaration $2 $3 $5 $8 $9 $11 }

VariableDeclarationList :
        Type IDENTIFIER SEMICOLON { VariableDeclarationList $1 $2 VariableDeclarationListEmpty }
        | Type IDENTIFIER SEMICOLON VariableDeclarationList { VariableDeclarationList $1 $2 $4 }
        | { VariableDeclarationListEmpty }

FormalList :
        Type IDENTIFIER { FormalList $1 $2 FormalListEmpty }
        | Type IDENTIFIER FormalList { FormalList $1 $2 $3 }

Type :
        INT LBRACKET RBRACKET { TypeIntArray }
        | BOOLEAN { TypeBoolean }
        | INT { TypeInt }
        | IDENTIFIER { TypeIdent $1 }

StatementList :
        Statement { StatementList Empty $1 }
        | StatementList Statement { StatementList $1 $2 }

Exp :
        Exp op Exp { ExpOp $1 $2 $3 }
        | Exp comop { ExpComOp $1 $2 $3 }
        | Exp LBRACKET Exp RBRACKET { ExpArray $1 $3 }
        | Exp DOT "length" { ExpLength $1 }
        | Exp DOT IDENTIFIER LBRACE ExpList RBRACE { ExpFCall $1 $3 $5 }
        | INTLITERAL { ExpInt $1 }
        | BOOLLITERAL { ExpBool $1 }
        | IDENTIFIER { ExpIdent $1 }
        | THIS { ExpThis $1 }
        | NEW INT "[" Exp "]" { ExpNewInt $4 }
        | NEW IDENTIFIER LBRACE RBRACE { ExpNewIdent $2 }
        | "!" Exp { ExpNot $2 }
        | LBRACE Exp RBRACE { ExpExp $2 }

ExpList :
        Exp { ExpList $1 }
        | Exp ExpRest { ExpList $1 $2 }
        | { ExpListEmpty }

ExpRest :
        COLON Exp { ExpRest $2 }

{
    parseError :: [Token] -> a
    parseError _ = error "Parse error"

    data Program
        = Prorgram MainClass ClassDeclarationList
        deriving (show, Eq)

    data MainClass
        = MClas String String Statement
        deriving (show, Eq)

    data ClassDeclarationList
        = ClassDeclarationList ClassDeclaration ClassDeclarationList
        | ClassEmpty
        deriving (show, Eq)
    
    data MethodDeclarationList
        = MethodDeclarationList MethodDeclaration MethodDeclarationList
        | MethodEmpty
        deriving (show, Eq)

    data MethodDeclaration
        = MethodDeclaration Type IDENTIFIER FormalList VariableDeclarationList StatementList Exp
        deriving (show, Eq)

    data VariableDeclarationList
        = VariableDeclarationList Type IDENTIFIER VariableDeclarationList
        | VariableDeclarationListEmpty
        deriving (show, Eq)

    data FormalList
        = FormalList Type IDENTIFIER FormalList
        | FormalListEmpty
        deriving (show, Eq)

    data Type
        = TypeIntArray
        | TypeBoolean
        | TypeInt
        | TypeIdent TypeIdent
        deriving (show, Eq)

    data Statement
        = Statement String
        | SList StatementList
        | SIfElse Exp Statement Statement
        | SWhile Exp Statement
        | SPrint Exp
        | SEqual IDENTIFIER Exp
        | SArrayEqual IDENTIFIER Exp Exp
        | StatementError
        deriving (show, Eq)

    data StatementList
        = StatementList StatementList Statement
        | Empty
        deriving (show, Eq)

    data Exp
        = Exp String
        | ExpOp Exp CHAR Exp
        | ExpComOp Exp CHAR Exp
        | ExpArray Exp Exp
        | ExpFCall Exp IDENTIFIER ExpList
        | ExpInt INT
        | ExpNewInt Exp
        | ExpBool BOOLLITERAL
        | ExpIdent IDENTIFIER
        | ExpNewIdent IDENTIFIER
        | ExpExp Exp
        | ExpThis
        | ExpNot Exp
        | ExpLength Exp
        | ExpError
        deriving (show, Eq)

    data op
        = AND
        | LESS
        | PLUS
        | MINUS
        | TIMES
        deriving (show, Eq)

    type IDENTIFIER = String
    type INTLITERAL = INT

    data ExpList
        = ExpList Exp ExpRest
        | ExpListEmpty
        | ExpListExp Exp
        deriving (show, Eq)

    data ExpRest
        = ExpRest Exp
        deriving (show, Eq)

    main = do
    inputString <- getContents
    print "start parser"
    let parseTree = parse (alexScanTokens inputString)  
    putStrLn ("Parse Tree:" ++ show(parseTree))
    print "done"
}