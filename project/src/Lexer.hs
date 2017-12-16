module Lexer where

import Lexer.Lexer
import System.IO.Unsafe 

lex :: String -> [Token]
lex = Lexer.Lexer.alexScanTokens

