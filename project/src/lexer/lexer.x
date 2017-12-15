{
module Lexer.Lexer  (alexScanTokens, Token(..)) where
import Lexer.Token
}

%wrapper "basic"

$digit = 0-9
$alpha = [a-zA-Z]

tokens :-

    -- Ignore
    $white+ ; 
    "//".*  ;

    -- Operators
    -- Arithmetics
    \+                { \s -> ADD }
    \-                { \s -> SUBTRACT }
    \*                { \s -> MULTIPLY }
    \/                { \s -> DIVIDE }
    \%                { \s -> MODULO }
    \+\+              { \s -> INCREMENT }
    \-\-              { \s -> DECREMENT }

    -- Logical
    \!                { \s -> NOT }
    \&\&              { \s -> AND }
    \|\|              { \s -> OR }
    \=\=              { \s -> EQUAL }
    \!\=              { \s -> NOT_EQUAL }
    \<                { \s -> LESSER }
    \>                { \s -> GREATER }
    \<\=              { \s -> LESSER_EQUAL }
    \>\=              { \s -> GREATER_EQUAL }

    -- Bitwise
    \&                { \s -> BITWISE_AND }
    \|                { \s -> BITWISE_OR }
    \^                { \s -> BITWISE_XOR }
    \<\<              { \s -> SHIFTLEFT }
    \>\>              { \s -> SHIFTRIGHT }
    \>\>\>            { \s -> UNSIGNED_SHIFTRIGHT }

    -- Punctuators
    \(                { \s -> LEFT_PARANTHESES }
    \)                { \s -> RIGHT_PARANTHESES }
    \{                { \s -> LEFT_BRACE }
    \}                { \s -> RIGHT_BRACE }
    -- \[                { \s -> LEFT_BRACKET }
    -- \]                { \s -> RIGHT_BRACKET }
    \.                { \s -> DOT }
    \,                { \s -> COMMA }
    \:                { \s -> COLON }
    \;                { \s -> SEMICOLON }
    -- \#                { \s -> SHARP }

    -- Assignment
    \=                { \s -> ASSIGN }
    \+\=              { \s -> ADD_ASSIGN }
    \-\=              { \s -> SUBTRACT_ASSIGN }
    \*\=              { \s -> MULTIPLY_ASSIGN }
    \/\=              { \s -> DIVIDE_ASSIGN }
    \%\=              { \s -> MODULO_ASSIGN }
    \&\=              { \s -> AND_ASSIGN }
    \|\=              { \s -> OR_ASSIGN }
    \^\=              { \s -> XOR_ASSIGN }
    \<\<\=            { \s -> SHIFTLEFT_ASSIGN }
    \>\>\=            { \s -> SHIFTRIGHT_ASSIGN }
    \>\>\>\=          { \s -> UNSIGNED_SHIFTRIGHT_ASSIGN }

    -- other
    instanceof        { \s -> INSTANCEOF }

    -- Keywords
    -- Types
    boolean           { \s -> BOOLEAN }
    char              { \s -> CHARACTER }
    int               { \s -> INTEGER }
    void              { \s -> VOID }

    -- loops
    for               { \s -> FOR }
    while             { \s -> WHILE }
    do                { \s -> DO }
    break             { \s -> BREAK }
    continue          { \s -> CONTINUE }

    -- Conditional
    if                { \s -> IF }
    else              { \s -> ELSE }
    switch            { \s -> SWITCH }
    case              { \s -> CASE }
    \?                { \s -> QUESTIONMARK }

    -- Class
    class             { \s -> CLASS}
    new               { \s -> NEW }
    private           { \s -> PRIVATE }
    -- protected         { \s -> PROTECTED }
    public            { \s -> PUBLIC }
    static            { \s -> STATIC }
    this              { \s -> THIS }

    -- Method
    return            { \s -> RETURN }

    -- Literals
    true              { \s -> BOOLEAN_LITERAL(True) }
    false             { \s -> BOOLEAN_LITERAL(False) }
    null              { \s -> JNULL }
    $digit+           { \s -> INTEGER_LITERAL (fromIntegral (read s)) }
    $alpha [$alpha $digit \_ \']*   { \s -> IDENTIFIER s }
    \'$alpha\'        { \s ->  CHARACTER_LITERAL ((\(_:snd:_) -> snd) s) }

    -- Other
    final             { \s -> FINAL }
{
}
