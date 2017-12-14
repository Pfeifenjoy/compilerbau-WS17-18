{
module Parser.Parser  where
import Lexer.Token
import ABSTree
import Data.Int

}

%name parse
%tokentype { Lexer.Token.Token }
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
    COMMA {COMMA}
%%

Statement : RETURN Expr { Return $2 }
          | Block       { $1 }
          | WHILE LBRACE Expr RBRACE Statement { While $3 $5 }
          | DO Statement WHILE LBRACE Expr RBRACE { DoWhile $5 $2 }
          | FOR LBRACE Statement SEMICOLON Expr SEMICOLON Statement RBRACE Statement { For $3 $5 $7 $9 }
          | BREAK { Break }
          | CONTINUE { Continue }
          | IF LBRACE Expr RBRACE Statement ELSE Statement { If $3 $5 (Just $7) }
          | IF LBRACE Expr RBRACE Statement { If $3 $5 Nothing }
          | StmtExpr { StmtExprStmt $1 }

Expr : Expr PLUS Expr                       { Binary "+" $1 $3 }
     | THIS                                 { This }
     | IDENTIFIER                           { LocalOrFieldVar $1 }
     | Expr DOT IDENTIFIER                  { InstVar $1 $3 }
     -- Operators
     | EXCLMARK Expr                        { Unary "!" $2 }
     | Expr PLUS Expr                       { Binary "+" $1 $3 }
     | Expr MINUS Expr                      { Binary "-" $1 $3 }
     | Expr MUL Expr                        { Binary "*" $1 $3 }
     | Expr DIV Expr                        { Binary "/" $1 $3 }
     | Expr MOD Expr                        { Binary "%" $1 $3 }
     | Expr AND Expr                        { Binary "&&" $1 $3 }
     | Expr OR Expr                         { Binary "||" $1 $3 }
     | Expr XOR Expr                        { Binary "^" $1 $3 }
     | Expr QUESMARK Expr COLON Expr        { Ternary $1 $3 $5 }
     | INCREMENT Expr                       { StmtExprExpr (Assign $2 (Binary "+" $2 (IntegerLiteral 1))) }
     | DECREMENT Expr                       { StmtExprExpr (Assign $2 (Binary "-" $2 (IntegerLiteral 1))) }
     -- TODO back increment, back drecrement
     -- Literals
     | BOOLLITERAL                          { BooleanLiteral $1 }
     | CHARLITERAL                          { CharLiteral $1 }
     | INTLITERAL                           { IntegerLiteral (fromIntegral $1) }
     | JNULL                                { JNull }
     | StmtExpr                             { StmtExprExpr $1 }

Arguments : Expr { [$1] }
            | Arguments COMMA Expr { $1 ++ [$3] }
 
Statements : Statement { [$1] }
          | Statements Statement { $1 ++ [$2] }

Block : LBRACKET RBRACKET { Block [] }
      | LBRACKET Statements RBRACKET { Block $2 }

StmtExpr : Expr ASSIGN Expr { Assign $1 $3 }
         | NEW IDENTIFIER LBRACE Arguments RBRACE { New $2 $4 }
         | Expr DOT IDENTIFIER LBRACE Arguments RBRACE { MethodCall $1 $3 $5 }

{
parseError :: [Lexer.Token.Token] -> a
parseError _ = error "Parse error"
}
