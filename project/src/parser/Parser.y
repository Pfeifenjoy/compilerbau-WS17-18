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
    ADD                                 { ADD }
    SUBTRACT                            { SUBTRACT }
    MULTIPLY                            { MULTIPLY }
    DIVIDE                              { DIVIDE }
    MODULO                              { MODULO }
    INCREMENT                           { INCREMENT }
    DECREMENT                           { DECREMENT }
    -- Logical
    NOT                                 { NOT }
    AND                                 { AND }
    OR                                  { OR }
    EQUAL                               { EQUAL }
    NOT_EQUAL                           { NOT_EQUAL }
    LESSER                              { LESSER }
    GREATER                             { GREATER }
    LESSER_EQUAL                        { LESSER_EQUAL }
    GREATER_EQUAL                       { GREATER_EQUAL }
    -- Bitwise
    BITWISE_AND                         { BITWISE_AND }
    BITWISE_OR                          { BITWISE_OR }
    BITWISE_XOR                         { BITWISE_XOR }
    SHIFTLEFT                           { SHIFTLEFT }
    SHIFTRIGHT                          { SHIFTRIGHT }
    UNSIGNED_SHIFTRIGHT                 { UNSIGNED_SHIFTRIGHT }
    -- Punctuators
    LEFT_PARANTHESES                    { LEFT_PARANTHESES }
    RIGHT_PARANTHESES                   { RIGHT_PARANTHESES }
    -- LEFT_BRACKET                        { LEFT_BRACKET }
    -- RIGHT_BRACKET                       { RIGHT_BRACKET }
    LEFT_BRACE                          { LEFT_BRACE }
    RIGHT_BRACE                         { RIGHT_BRACE }
    DOT                                 { DOT }
    COMMA                               { COMMA }
    COLON                               { COLON }
    SEMICOLON                           { SEMICOLON }
    -- Assignment
    ASSIGN                              { ASSIGN }
    ADD_ASSIGN                          { ADD_ASSIGN }
    SUBTRACT_ASSIGN                     { SUBTRACT_ASSIGN }
    MULTIPLY_ASSIGN                     { MULTIPLY_ASSIGN }
    DIVIDE_ASSIGN                       { DIVIDE_ASSIGN }
    MODULO_ASSIGN                       { MODULO_ASSIGN }
    AND_ASSIGN                          { AND_ASSIGN }
    OR_ASSIGN                           { OR_ASSIGN }
    XOR_ASSIGN                          { XOR_ASSIGN }
    SHIFTLEFT_ASSIGN                    { SHIFTLEFT_ASSIGN }
    SHIFTRIGHT_ASSIGN                   { SHIFTRIGHT_ASSIGN }
    UNSIGNED_SHIFTRIGHT_ASSIGN          { UNSIGNED_SHIFTRIGHT_ASSIGN }
    -- Types
    BOOLEAN                             { BOOLEAN }
    CHARACTER                           { CHARACTER }
    INTEGER                             { INTEGER }
    VOID                                { VOID }
    -- Loops
    FOR                                 { FOR }
    WHILE                               { WHILE }
    DO                                  { DO }
    BREAK                               { BREAK }
    CONTINUE                            { CONTINUE }
    -- Conditional
    IF                                  { IF }
    ELSE                                { ELSE }
    SWITCH                              { SWITCH }
    CASE                                { CASE }
    QUESTIONMARK                        { QUESTIONMARK }
    -- Class
    CLASS                               { CLASS }
    NEW                                 { NEW }
    PRIVATE                             { PRIVATE }
    PUBLIC                              { PUBLIC }
    -- | PROTECTED
    STATIC                              { STATIC }
    THIS                                { THIS }
    -- Method
    RETURN                              { RETURN }
    -- Literals
    BOOLEAN_LITERAL                     { BOOLEAN_LITERAL $$ }
    CHARACTER_LITERAL                   { CHARACTER_LITERAL  $$ }
    INTEGER_LITERAL                     { INTEGER_LITERAL $$ }
    IDENTIFIER                          { IDENTIFIER $$ }
    JNULL                               { JNULL }
    -- Other
    INSTANCEOF                          { INSTANCEOF }
    FINAL                               { FINAL }

-- Further information see https://introcs.cs.princeton.edu/java/11precedence/
%right in
%right ASSIGN ADD_ASSIGN SUBTRACT_ASSIGN MULTIPLY_ASSIGN DIVIDE_ASSIGN
        MODULO_ASSIGN AND_ASSIGN OR_ASSIGN XOR_ASSIGN SHIFTLEFT_ASSIGN
        SHIFTRIGHT_ASSIGN UNSIGNED_SHIFTRIGHT_ASSIGN
%right QUESTIONMARK COLON
%left OR
%left AND
%left BITWISE_XOR
%left BITWISE_OR
%left BITWISE_AND
%left EQUAL NOT_EQUAL
%nonassoc LESSER GREATER LOWER_EQUAL LESSER_EQUAL INSTANCEOF
%left SHIFTLEFT SHIFTRIGHT UNSIGNED_SHIFTRIGHT
%left ADD SUBTRACT
%left MULTIPLY DIVIDE MODULO
%left NOT -- todo unary increment, decrement, plus, minus
%left DOT -- todo [] ()
%nonassoc INCREMENT DECREMENT --todo postfix
%%

SingleStatement : Statement SEMICOLON                { $1 }
                | Block                              { $1 }

Statement
	: RETURN Expression                  { Return $2 }
	| WHILE LEFT_PARANTHESES Expression
	RIGHT_PARANTHESES SingleStatement
	                                     { While $3 $5 }
	| DO SingleStatement WHILE
	LEFT_PARANTHESES Expression RIGHT_PARANTHESES
	                                     { DoWhile $5 $2 }
	| FOR LEFT_PARANTHESES Statement
	SEMICOLON Expression SEMICOLON
	Statement RIGHT_PARANTHESES SingleStatement
	                                     { For $3 $5 $7 $9 }
	| BREAK                              { Break }
	| CONTINUE                           { Continue }
	| IF LEFT_PARANTHESES Expression RIGHT_PARANTHESES
	SingleStatement ELSE SingleStatement
	                                     { If $3 $5 (Just $7) }
	| IF LEFT_PARANTHESES Expression RIGHT_PARANTHESES
	SingleStatement
	                                     { If $3 $5 Nothing }
	| StatementExpression                { StmtExprStmt $1 }


Expression
	: THIS                               { This }
	| IDENTIFIER                         { LocalOrFieldVar $1 }
	-- | Expression DOT IDENTIFIER          { InstVar $1 $3 }
	-- Operators
	| NOT Expression                     { Unary "!" $2 }
	| Expression ADD Expression          { Binary "+" $1 $3 }
	| Expression SUBTRACT Expression     { Binary "-" $1 $3 }
	| Expression MULTIPLY Expression     { Binary "*" $1 $3 }
	| Expression DIVIDE Expression       { Binary "/" $1 $3 }
	| Expression MODULO Expression       { Binary "%" $1 $3 }
	| Expression AND Expression          { Binary "&&" $1 $3 }
	| Expression OR Expression           { Binary "||" $1 $3 }
	| Expression BITWISE_AND Expression  { Binary "&" $1 $3 }
	| Expression BITWISE_OR Expression   { Binary "|" $1 $3 }
	| Expression BITWISE_XOR Expression  { Binary "^" $1 $3 }
	| Expression QUESTIONMARK Expression COLON Expression
	                                     { Ternary $1 $3 $5 }
	| INCREMENT Expression               { StmtExprExpr (Assign $2 (Binary "+" $2 (IntegerLiteral 1))) }
	| DECREMENT Expression               { StmtExprExpr (Assign $2 (Binary "-" $2 (IntegerLiteral 1))) }
	-- TODO back increment, back drecrement
	-- Paranthesis
	| LEFT_PARANTHESES Expression RIGHT_PARANTHESES
	                                     { $2 }
	-- Literals
	| BOOLEAN_LITERAL                    { BooleanLiteral $1 }
	| CHARACTER_LITERAL                  { CharLiteral $1 }
	| INTEGER_LITERAL                    { IntegerLiteral (fromIntegral $1) }
	| JNULL                              { JNull }
	| StatementExpression                { StmtExprExpr $1 }

Arguments
	: Expression                         { [$1] }
	| Arguments COMMA Expression         { $1 ++ [$3] }
 
Statements
	: SingleStatement                    { [$1] }
	| Statements SingleStatement         { $1 ++ [$2] }

Block
	: LEFT_BRACE RIGHT_BRACE             { Block [] }
	| LEFT_BRACE Statements RIGHT_BRACE  { Block $2 }

StatementExpression
	: Expression ASSIGN Expression       { Assign $1 $3 }
	| NEW IDENTIFIER LEFT_PARANTHESES
		Arguments RIGHT_PARANTHESES      { New $2 $4 }
	| Expression DOT IDENTIFIER
		LEFT_PARANTHESES Arguments
		RIGHT_PARANTHESES                { MethodCall $1 $3 $5 }

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
