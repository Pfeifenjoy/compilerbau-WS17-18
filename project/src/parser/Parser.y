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
    -- Arithmentics
    ADD { ADD }
    SUBTRACT { SUBTRACT }
    MULTIPLY { MULTIPLY }
    DIVIDE { DIVIDE }
    MODULO { MODULO }
    INCREMENT { INCREMENT }
    DECREMENT { DECREMENT }
    -- Logical
    NOT { NOT }
    AND { AND }
    OR { OR }
    EQUAL { EQUAL }
    NOT_EQUAL { NOT_EQUAL }
    LESSER { LESSER }
    GREATER { GREATER }
    LESSER_EQUAL { LESSER_EQUAL }
    GREATER_EQUAL { GREATER_EQUAL }
    -- Bitwise
    BITWISE_AND { BITWISE_AND }
    BITWISE_OR { BITWISE_OR }
    BITWISE_XOR { BITWISE_XOR }
    SHIFTLEFT { SHIFTLEFT }
    SHIFTRIGHT { SHIFTRIGHT }
    UNSIGNED_SHIFTRIGHT { UNSIGNED_SHIFTRIGHT }
    -- Punctuators
    LEFT_PARANTHESES { LEFT_PARANTHESES }
    RIGHT_PARANTHESES { RIGHT_PARANTHESES }
    -- | LEFT_BRACKET
    -- | RIGHT_BRACKET
    LEFT_BRACE { LEFT_BRACE }
    RIGHT_BRACE { RIGHT_BRACE }
    DOT { DOT }
    COMMA { COMMA }
    COLON { COLON }
    SEMICOLON { SEMICOLON }
    -- Assignment
    ASSIGN { ASSIGN }
    ADD_ASSIGN { ADD_ASSIGN }
    SUBTRACT_ASSIGN { SUBTRACT_ASSIGN }
    MULTIPLY_ASSIGN { MULTIPLY_ASSIGN }
    DIVIDE_ASSIGN { DIVIDE_ASSIGN }
    MODULO_ASSIGN { MODULO_ASSIGN }
    AND_ASSIGN { AND_ASSIGN }
    OR_ASSIGN { OR_ASSIGN }
    XOR_ASSIGN { XOR_ASSIGN }
    SHIFTLEFT_ASSIGN { SHIFTLEFT_ASSIGN }
    SHIFTRIGHT_ASSIGN { SHIFTRIGHT_ASSIGN }
    UNSIGNED_SHIFTRIGHT_ASSIGN { UNSIGNED_SHIFTRIGHT_ASSIGN }
    -- Types
    BOOLEAN { BOOLEAN }
    CHARACTER { CHARACTER }
    INTEGER { INTEGER }
    VOID { VOID }
    -- Loops
    FOR { FOR }
    WHILE { WHILE }
    DO { DO }
    BREAK { BREAK }
    CONTINUE { CONTINUE }
    -- Conditional
    IF { IF }
    ELSE { ELSE }
    SWITCH { SWITCH }
    CASE { CASE }
    QUESTIONMARK { QUESTIONMARK }
    -- Class
    CLASS { CLASS }
    NEW { NEW }
    PRIVATE { PRIVATE }
    PUBLIC { PUBLIC }
    -- | PROTECTED
    STATIC { STATIC }
    THIS { THIS }
    -- Method
    RETURN { RETURN }
    -- Literals
    BOOLEAN_LITERAL { BOOLEAN_LITERAL $$ }
    CHARACTER_LITERAL  { CHARACTER_LITERAL  $$ }
    INTEGER_LITERAL { INTEGER_LITERAL $$ }
    IDENTIFIER { IDENTIFIER $$ }
    JNULL { JNULL }
    -- Other
    INSTANCEOF { INSTANCEOF }
    FINAL { FINAL }
%%

Statement : RETURN Expr { Return $2 }
          | Block       { $1 }
          | WHILE LEFT_PARANTHESES Expr RIGHT_PARANTHESES Statement { While $3 $5 }
          | DO Statement WHILE LEFT_PARANTHESES Expr RIGHT_PARANTHESES { DoWhile $5 $2 }
          | FOR LEFT_PARANTHESES Statement SEMICOLON Expr SEMICOLON Statement RIGHT_PARANTHESES Statement { For $3 $5 $7 $9 }
          | BREAK { Break }
          | CONTINUE { Continue }
          | IF LEFT_PARANTHESES Expr RIGHT_PARANTHESES Statement ELSE Statement { If $3 $5 (Just $7) }
          | IF LEFT_PARANTHESES Expr RIGHT_PARANTHESES Statement { If $3 $5 Nothing }
          | StmtExpr { StmtExprStmt $1 }

Expr : THIS                                 { This }
     | IDENTIFIER                           { LocalOrFieldVar $1 }
     | Expr DOT IDENTIFIER                  { InstVar $1 $3 }
     -- Operators
     | NOT Expr                             { Unary "!" $2 }
     | Expr ADD Expr                        { Binary "+" $1 $3 }
     | Expr SUBTRACT Expr                   { Binary "-" $1 $3 }
     | Expr MULTIPLY Expr                   { Binary "*" $1 $3 }
     | Expr DIVIDE Expr                     { Binary "/" $1 $3 }
     | Expr MODULO Expr                     { Binary "%" $1 $3 }
     | Expr AND Expr                        { Binary "&&" $1 $3 }
     | Expr OR Expr                         { Binary "||" $1 $3 }
     | Expr BITWISE_XOR Expr                { Binary "^" $1 $3 }
     | Expr QUESTIONMARK Expr COLON Expr        { Ternary $1 $3 $5 }
     | INCREMENT Expr                       { StmtExprExpr (Assign $2 (Binary "+" $2 (IntegerLiteral 1))) }
     | DECREMENT Expr                       { StmtExprExpr (Assign $2 (Binary "-" $2 (IntegerLiteral 1))) }
     -- TODO back increment, back drecrement
     -- Literals
     | BOOLEAN_LITERAL                          { BooleanLiteral $1 }
     | CHARACTER_LITERAL                          { CharLiteral $1 }
     | INTEGER_LITERAL                           { IntegerLiteral (fromIntegral $1) }
     | JNULL                                { JNull }
     | StmtExpr                             { StmtExprExpr $1 }

Arguments : Expr { [$1] }
            | Arguments COMMA Expr { $1 ++ [$3] }
 
Statements : Statement { [$1] }
          | Statements Statement { $1 ++ [$2] }

Block : LEFT_BRACE RIGHT_BRACE { Block [] }
      | LEFT_BRACE Statements RIGHT_BRACE { Block $2 }

StmtExpr : Expr ASSIGN Expr { Assign $1 $3 }
         | NEW IDENTIFIER LEFT_PARANTHESES Arguments RIGHT_PARANTHESES { New $2 $4 }
         | Expr DOT IDENTIFIER LEFT_PARANTHESES Arguments RIGHT_PARANTHESES { MethodCall $1 $3 $5 }

-- Type : IDENTIFIER { Type $1 }
-- 
-- VariableDecle : Type IDENTIFIER { VariableDecl $1 $2 False }
--               | FINAL Type IDENTIFIER { VariableDecl $1 $2 true }
-- 
-- FieldDecl : 
-- 
-- ClassBody : MethodDecl
--           | FieldDecl
-- 
-- Class : CLASS IDENTIFIER LEFT_BRACE ClassBody RIGHT_BRACE { Class $2 $4 }

{
parseError :: [Lexer.Token.Token] -> a
parseError _ = error "Parse error"
}
