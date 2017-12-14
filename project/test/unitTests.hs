module Main where

import Test.HUnit
import Lexer.Token
import Lexer


test1 :: Test
test1 = TestCase (assertEqual "Equal-Assert" [Lexer.Token.INT] (Lexer.lex "int"))

tests :: Test
tests = TestList [TestLabel "test1" test1]
 
main = do 
    runTestTT tests

         
