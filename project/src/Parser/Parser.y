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
    DEFAULT                             { DEFAULT }
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
%nonassoc LESSER GREATER LESSER_EQUAL GREATER_EQUAL INSTANCEOF
%left SHIFTLEFT SHIFTRIGHT UNSIGNED_SHIFTRIGHT
%left ADD SUBTRACT
%left MULTIPLY DIVIDE MODULO
%left NOT
%left DOT
%nonassoc INCREMENT DECREMENT
%nonassoc THEN
%nonassoc ELSE
%%

Program
    : Class                                 { [$1] }
    | Program Class                         { $1 ++ [$2] }
    | Program SEMICOLON                     { $1 }

Statement
    : SingleStatement SEMICOLON             { $1 }
    | Block                                 { $1 }
    | WHILE LEFT_PARANTHESES Expression
        RIGHT_PARANTHESES Statement
                                            { While $3 $5 }
    | DO Statement WHILE
        LEFT_PARANTHESES Expression RIGHT_PARANTHESES
                                            { DoWhile $5 $2 }
    | FOR LEFT_PARANTHESES SingleStatement
        SEMICOLON Expression SEMICOLON
        SingleStatement RIGHT_PARANTHESES Statement
                                            { For $3 $5 $7 $9 }
    | FOR LEFT_PARANTHESES
        SEMICOLON SEMICOLON
        RIGHT_PARANTHESES Statement
                                            { While (BooleanLiteral True) $6 }
    | FOR LEFT_PARANTHESES SingleStatement
        SEMICOLON SEMICOLON
        RIGHT_PARANTHESES Statement
                                            { For $3 (BooleanLiteral True) (Block []) $7 }
    | FOR LEFT_PARANTHESES
        SEMICOLON Expression SEMICOLON
        RIGHT_PARANTHESES Statement
                                            { For (Block []) $4 (Block []) $7 }
    | FOR LEFT_PARANTHESES
        SEMICOLON SEMICOLON
        SingleStatement RIGHT_PARANTHESES Statement
                                            { For (Block []) (BooleanLiteral True) $5 $7 } 
    | FOR LEFT_PARANTHESES SingleStatement
        SEMICOLON Expression SEMICOLON
        RIGHT_PARANTHESES Statement
                                            { For $3 $5 (Block []) $8 }
    | FOR LEFT_PARANTHESES
        SEMICOLON Expression SEMICOLON
        SingleStatement RIGHT_PARANTHESES Statement
                                            { For (Block []) $4 $6 $8 }   
    | FOR LEFT_PARANTHESES SingleStatement
        SEMICOLON SEMICOLON
        SingleStatement RIGHT_PARANTHESES Statement
                                            { For $3 (BooleanLiteral True) $6 $8 }               
    | IF LEFT_PARANTHESES Expression RIGHT_PARANTHESES
        Statement ELSE Statement
                                            { If $3 $5 (Just $7) }
    | IF LEFT_PARANTHESES Expression
        RIGHT_PARANTHESES Statement
        %prec THEN                          { If $3 $5 Nothing }
    | Switch                                { $1 }
 
Statements
    : Statement                       { [$1] }
    | Statements Statement            { $1 ++ [$2] }

Block
    : LEFT_BRACE RIGHT_BRACE                { Block [] }
    | LEFT_BRACE Statements RIGHT_BRACE     { Block $2 }

SwitchCase
    : CASE Expression COLON Statements      { SwitchCase $2 $4 }

DefaultCase
    : DEFAULT Statements                    { $2 }

SwitchCases
    : SwitchCase                            { [$1] }
    | SwitchCases SwitchCase                { $1 ++ [$2] }

Switch
    : SWITCH Expression
        LEFT_BRACE SwitchCases RIGHT_BRACE  { Switch $2 $4 Nothing }
    | SWITCH Expression
        LEFT_BRACE
            SwitchCases
            DefaultCase
        RIGHT_BRACE                         { Switch $2 $4 $ Just $5 }

SingleVariableDecl
    : Type IDENTIFIER                       { VariableDecl $2 $1 False Nothing }
    | Type IDENTIFIER ASSIGN Expression     { VariableDecl $2 $1 False $ Just $4 }
    | FINAL Type IDENTIFIER                 { VariableDecl $3 $2 True Nothing }
    | FINAL Type IDENTIFIER ASSIGN
        Expression                          { VariableDecl $3 $2 False $ Just $5 }

RestVariableDecl
    : COMMA IDENTIFIER                      { ($2, Nothing) }
    | COMMA IDENTIFIER ASSIGN Expression    { ($2, Just $4) }

RestVariableDecls
    : RestVariableDecl                      { [$1] }
    | RestVariableDecls RestVariableDecl    { $1 ++ [$2] }

VariableDecl
    : SingleVariableDecl                    { [$1] }
    | SingleVariableDecl RestVariableDecls  { joinVariableDecls $1 $2 }

LocalVariableDecl
    : VariableDecl                          { LocalVarDecls $1 }

SingleStatement
    :                                       { Block [] }
    | RETURN Expression                     { ABSTree.Return $2 }
    | BREAK                                 { Break }
    | CONTINUE                              { Continue }
    | LocalVariableDecl                     { $1 }
    | StatementExpression                   { StmtExprStmt $1 }


Expression
    : THIS                                  { This }
    | IDENTIFIER                            { LocalOrFieldVar $1 }
    | Expression DOT IDENTIFIER             { InstVar $1 $3 }
    -- Operators
    | NOT Expression                        { Unary "!" $2 }
    | Expression ADD Expression             { Binary "+" $1 $3 }
    | Expression SUBTRACT Expression        { Binary "-" $1 $3 }
    | Expression MULTIPLY Expression        { Binary "*" $1 $3 }
    | Expression DIVIDE Expression          { Binary "/" $1 $3 }
    | Expression MODULO Expression          { Binary "%" $1 $3 }
    | Expression AND Expression             { Binary "&&" $1 $3 }
    | Expression OR Expression              { Binary "||" $1 $3 }
    | Expression BITWISE_AND Expression     { Binary "&" $1 $3 }
    | Expression BITWISE_OR Expression      { Binary "|" $1 $3 }
    | Expression BITWISE_XOR Expression     { Binary "^" $1 $3 }
    | Expression SHIFTLEFT Expression       { Binary "<<" $1 $3 }
    | Expression SHIFTRIGHT Expression      { Binary ">>" $1 $3 }
    | Expression UNSIGNED_SHIFTRIGHT
        Expression                          { Binary ">>>" $1 $3 }
    | Expression QUESTIONMARK Expression
        COLON Expression                    { Ternary $1 $3 $5 }
    | Expression EQUAL Expression           { Binary "==" $1 $3 }
    | Expression NOT_EQUAL Expression       { Unary "!" $ Binary "==" $1 $3 }
    | Expression LESSER Expression          { Binary "<" $1 $3 }
    | Expression GREATER Expression         { Binary ">" $1 $3 }
    | Expression LESSER_EQUAL Expression    { Binary "<=" $1 $3 }
    | Expression GREATER_EQUAL Expression   { Binary ">=" $1 $3 }
    | Expression INSTANCEOF Type            { InstanceOf $1 $3 }
    -- Paranthesis
    | LEFT_PARANTHESES Expression RIGHT_PARANTHESES
                                            { $2 }
    -- Literals
    | BOOLEAN_LITERAL                       { BooleanLiteral $1 }
    | CHARACTER_LITERAL                     { CharLiteral $1 }
    | INTEGER_LITERAL                       { IntegerLiteral (fromIntegral $1) }
    | JNULL                                 { JNull }
    | StatementExpression                   { StmtExprExpr $1 }

Arguments
    :                                       { [] }
    | Expression                            { [$1] }
    | Arguments COMMA Expression            { $1 ++ [$3] }

StatementExpression
    : Expression ASSIGN Expression          { Assign $1 $3 }
    | NEW IDENTIFIER LEFT_PARANTHESES
        Arguments RIGHT_PARANTHESES         { New $2 $4 }
    | Expression ADD_ASSIGN Expression      { Assign $1 $ Binary "+" $1 $3 }
    | Expression SUBTRACT_ASSIGN Expression { Assign $1 $ Binary "-" $1 $3 }
    | Expression MULTIPLY_ASSIGN Expression { Assign $1 $ Binary "*" $1 $3 }
    | Expression DIVIDE_ASSIGN Expression   { Assign $1 $ Binary "/" $1 $3 }
    | Expression MODULO_ASSIGN Expression   { Assign $1 $ Binary "%" $1 $3 }
    | Expression AND_ASSIGN Expression      { Assign $1 $ Binary "&" $1 $3 }
    | Expression OR_ASSIGN Expression       { Assign $1 $ Binary "|" $1 $3 }
    | Expression XOR_ASSIGN Expression      { Assign $1 $ Binary "^" $1 $3 }
    | Expression SHIFTLEFT_ASSIGN Expression
                                            { Assign $1 $ Binary "<<" $1 $3 }
    | INCREMENT Expression                  { Assign $2 $ Binary "+" $2 $ IntegerLiteral 1 }
    | DECREMENT Expression                  { Assign $2 $ Binary "-" $2 $ IntegerLiteral 1 }
    | Expression INCREMENT                  { LazyAssign $1 $ Binary "+" $1 $ IntegerLiteral 1 }
    | Expression DECREMENT                  { LazyAssign $1 $ Binary "-" $1 $ IntegerLiteral 1 }
    | Expression SHIFTRIGHT_ASSIGN
        Expression                          { Assign $1 $ Binary ">>" $1 $3 }
    | Expression UNSIGNED_SHIFTRIGHT_ASSIGN
        Expression                          { Assign $1 $ Binary ">>" $1 $3 }
    | Expression DOT IDENTIFIER
        LEFT_PARANTHESES Arguments
        RIGHT_PARANTHESES                   { MethodCall $1 $3 $5 }

Type
    : IDENTIFIER                            { $1 }
    | BOOLEAN                               { "boolean" }
    | CHARACTER                             { "char" }
    | INTEGER                               { "int" }
    | VOID                                  { "void" }

FieldDecl
    : VariableDecl SEMICOLON                { FieldDecl $1 Public False }
    | PRIVATE VariableDecl SEMICOLON        { FieldDecl $2 Private False }
    | PRIVATE STATIC VariableDecl SEMICOLON { FieldDecl $3 Private True }
    | PUBLIC VariableDecl SEMICOLON         { FieldDecl $2 Public False }
    | PUBLIC STATIC VariableDecl SEMICOLON  { FieldDecl $3 Public True }

ArgumentDecl
    : Type IDENTIFIER                       { ArgumentDecl $2 $1 False }
    | FINAL Type IDENTIFIER                 { ArgumentDecl $3 $2 True }

ArgumentDecls
    : ArgumentDecl                          { [ $1 ] }
    | ArgumentDecls COMMA ArgumentDecl      { $1 ++ [ $3 ] }

MethodParameters
    :                                       { [] }
    | ArgumentDecls                         { $1 }

MethodDecl
    : Type IDENTIFIER
        LEFT_PARANTHESES MethodParameters
        RIGHT_PARANTHESES Block             { MethodDecl $2 $1 $4 $6 Public False }
    | STATIC Type IDENTIFIER
        LEFT_PARANTHESES MethodParameters
        RIGHT_PARANTHESES Block             { MethodDecl $3 $2 $5 $7 Public True }
    | PRIVATE Type IDENTIFIER
        LEFT_PARANTHESES MethodParameters
        RIGHT_PARANTHESES Block             { MethodDecl $3 $2 $5 $7 Private False }
    | PRIVATE STATIC Type IDENTIFIER
        LEFT_PARANTHESES MethodParameters
        RIGHT_PARANTHESES Block             { MethodDecl $4 $3 $6 $8 Private True }
    | PUBLIC Type IDENTIFIER
        LEFT_PARANTHESES MethodParameters
        RIGHT_PARANTHESES Block             { MethodDecl $3 $2 $5 $7 Public False }
    | PUBLIC STATIC Type IDENTIFIER
        LEFT_PARANTHESES MethodParameters
        RIGHT_PARANTHESES Block             { MethodDecl $4 $3 $6 $8 Public True }

ClassBody
    : FieldDecl                             { ( [$1], [] ) }
    | MethodDecl                            { ( [], [$1] ) }
    | ClassBody FieldDecl                   { ( (fst $1) ++ [$2], snd $1 ) }
    | ClassBody MethodDecl                  { ( fst $1, (snd $1) ++ [$2] ) }

Class
    : CLASS IDENTIFIER LEFT_BRACE
        ClassBody RIGHT_BRACE               { Class $2 (fst $4) (snd $4) }
    | CLASS IDENTIFIER LEFT_BRACE
        RIGHT_BRACE                         { Class $2 [] [] }

{
parseError :: [Lexer.Token.Token] -> a
parseError tokens = error ("Parse error " ++ (show tokens))

prototypeVariableDecl :: VariableDecl -> (String, Maybe Expr) -> VariableDecl
prototypeVariableDecl (VariableDecl _ t f _) (name, initial)
    = (VariableDecl name t f initial)

joinVariableDecls :: VariableDecl -> [(String, Maybe Expr)] -> [VariableDecl]
joinVariableDecls prototype other
    = [prototype] ++ (map (prototypeVariableDecl prototype) other)
}
