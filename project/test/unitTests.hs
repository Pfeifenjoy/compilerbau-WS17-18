module Tester where

import Test.HUnit
import Lexer.Token
import Lexer

data TestUnit = LexerUnit String [Token] [Token] -- Name, InputFile, CompareFile

outPut :: Bool -> String -> String
outPut cond name = if cond
                       then concat ["\x1b[32m", "Lex: [", name, "] passed", "\x1b[0m"]
                       else concat ["\x1b[35m", "Lex: [", name, "] failed", "\x1b[0m"]

runTest :: TestUnit -> String
runTest (LexerUnit name a b) = outPut (a == b) name

runTests :: [TestUnit] -> [String]
runTests a = map runTest a

firstTokenTest :: TestUnit
firstTokenTest = LexerUnit "Empty Class" [Lexer.Token.INT, Lexer.Token.IDENTIFIER "i", Lexer.Token.SEMICOLON] (Lexer.lex "int i;")

firstTokenTest2 :: TestUnit
firstTokenTest2 = LexerUnit "Identifier" [Lexer.Token.INT, Lexer.Token.IDENTIFIER "k", Lexer.Token.SEMICOLON] (Lexer.lex "int i;")

tests :: [TestUnit]
tests = [firstTokenTest, firstTokenTest2]
 
main = do
        mapM_ putStrLn (runTests tests)
 

         
