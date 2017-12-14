module Lexer where

import Lexer.Lexer

lex :: String -> [Token]
lex = Lexer.Lexer.alexScanTokens
