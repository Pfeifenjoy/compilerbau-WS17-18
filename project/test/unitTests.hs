module Main where

import Lexer.Token
import Lexer
import System.Directory
import EmptyClass.Steps
import InstanzVariable.Steps

data TestUnit = LexerUnit String [Token] [Token] -- TestName, TestTokens, FileTokens
                deriving(Eq, Show)

runTest :: TestUnit -> String
runTest (LexerUnit name a b) = if a == b
                               then concat ["\x1b[32m", "Lex: [", name, "] passed", "\x1b[0m"]
                               else concat ["\x1b[35m", "Lex: [", name, "] failed", "\x1b[0m", 
                                           "\n\t \x1b[36m expected: \x1b[0m ", (show a), 
                                           "\n\t \x1b[36m got: \x1b[0m ", (show b)]

runTests :: [TestUnit] -> [String]
runTests a = map runTest a


lexTests :: [TestUnit]
lexTests = [(LexerUnit "EmptyClass" emptyTokens (Lexer.lex "./test/EmptyClass/Class.java")),
         (LexerUnit "InstanzVariable" instanzVariableTokens (Lexer.lex "./test/InstanzVariable/Class.java"))
        ]

main = do
       mapM_ putStrLn (runTests lexTests)
        
 

         
