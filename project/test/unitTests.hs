module Main where

import Test.HUnit
import Token
import Lexer


test1 :: Test
test1 = TestCase (assertEqual "Equal-Assert" [Token.INTEGER] (Lexer.lex "test"))

tests :: Test
tests = TestList [TestLabel "test1" test1]
 
main = do 
    runTestTT tests

         