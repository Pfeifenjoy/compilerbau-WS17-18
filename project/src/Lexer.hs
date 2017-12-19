module Lexer where

import Lexer.Lexer
import Lexer.Token
import System.IO.Unsafe 

lex :: String -> [Token]
lex = Lexer.Lexer.alexScanTokens
