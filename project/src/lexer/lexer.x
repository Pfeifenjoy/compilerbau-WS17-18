{
module Lexer.Lexer  (alexScanTokens, Token(..)) where
import Lexer.Token
}

%wrapper "basic"

$digit = 0-9
$alpha = [a-zA-Z]

tokens :-

      $white+ ; 
      "//".*  ;

      \'$alpha\'    { \s ->  CHARLITERAL ((\(_:snd:_) -> snd) s) }
      \+\+         { \s -> INCREMENT }
    \+        { \s -> PLUS }
    \-\-        { \s -> DECREMENT }
    \-\>        { \s -> ARROW }
    \-        { \s -> MINUS }
    \*        { \s -> MUL }
    \/        { \s -> DIV }
    \%        { \s -> MOD }
    \&\&        { \s -> AND }
    \|\|        { \s -> OR }
    \(        { \s -> LBRACE }
    \)        { \s -> RBRACE }
    \{        { \s -> LBRACKET }
    \}        { \s -> RBRACKET }
    \=\=        { \s -> EQUAL }
    \!\=        { \s -> NOTEQUAL }
    \<\=        { \s -> LESSEQUAL }
    \>\=        { \s -> GREATEREQUAL }
    \<        { \s -> LESS }
    \>        { \s -> GREATER }
    \;        { \s -> SEMICOLON }
    \,        { \s -> COLON }
    \.        { \s -> DOT }
    \=        { \s -> ASSIGN }
    \#        { \s -> SHARP }

      boolean     { \s -> BOOLEAN }
      break        { \s  ->  BREAK }
      case        { \s  ->  CASE }
      char         { \s  ->  CHAR  }
      class        { \s  ->  CLASS}
      continue    { \s  ->  CONTINUE }
      do        { \s  ->  DO }
      else        { \s  ->  ELSE }
      for        { \s  ->  FOR }
      if        { \s  ->  IF }
      instanceof    { \s  ->  INSTANCEOF }
      int        { \s  ->  INT }
      new        { \s  ->  NEW }
      private    { \s  ->  PRIVATE }
      protected    { \s  ->  PROTECTED }
      public    { \s  ->  PUBLIC }
      return    { \s  ->  RETURN }
      static    { \s  ->  STATIC }
      switch    { \s  ->  SWITCH }
      this        { \s  ->  THIS }
      void        { \s  ->  VOID }
      while        { \s  ->  WHILE }
      true        { \s  -> BOOLLITERAL(True) }
      false        { \s  -> BOOLLITERAL(False) }
      null        { \s  ->  JNULL }
      $digit+     { \s -> INTLITERAL (read s) }
      $alpha [$alpha $digit \_ \']*   { \s -> IDENTIFIER s }
      
{
}
