module Lexer where

import Lexer.Lexer
import System.IO.Unsafe 

lex :: String -> [Token]
lex s = Lexer.Lexer.alexScanTokens (unsafePerformIO . readFile $ s)

