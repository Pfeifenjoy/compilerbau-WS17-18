module Main where

import           ABSTree
import           Arithmetic.Steps
import           BitWiseOperation.Steps
import           ClassAssign.Steps
import           ClassMethods.Steps
import           Data.List
import           EmptyClass.Steps
import           ForLoop.Steps
import           InstanzVariable.Steps
import           Lexer
import           Lexer.Token
import           LocalVariable.Steps
import           LogicOperations.Steps
import           SimpleIf.Steps
import           System.Directory
import           WhileLoop.Steps
import           WhileLoopCondition.Steps

data TestUnit = LexerUnit String [Token] -- TestName, TestTokens
              | ParserUnit String [Class] -- Testname, TestClasses
                deriving(Eq, Show)

getLexerName :: TestUnit -> String
getLexerName (LexerUnit name testToken) = name

getLexerTestToken :: TestUnit -> [Token]
getLexerTestToken (LexerUnit name testToken) = testToken

getLexerRealToken :: TestUnit -> [Token]
getLexerRealToken (LexerUnit name testToken) = Lexer.lex (concat ["./test/", name, "/Class.java"])

runTest :: TestUnit -> String
runTest (LexerUnit name a) = let b = Lexer.lex (concat ["./test/", name, "/Class.java"])
                             in
                             if a == b
                               then concat ["\x1b[32m", "Lexer: [", name, "] passed", "\x1b[0m"]
                               else concat ["\x1b[35m", "Lexer: [", name, "] failed", "\x1b[0m",
                                           "\n\t \x1b[36m expected: \x1b[0m ", (show a),
                                           "\n\t \x1b[36m got: \x1b[0m ", (show b),
                                           "\n\t \x1b[36m difference: \x1b[0m", (show (nub (foldr (++) [] [a \\ b, b \\a])))]
runTests :: [TestUnit] -> [String]
runTests a = map runTest a

-- checks whether a test is a success or not
isSuccess :: TestUnit -> Bool
isSuccess (LexerUnit name a) = a == (Lexer.lex (concat ["./test/", name, "/Class.java"]))

numberOfSuccess :: [TestUnit] -> Int
numberOfSuccess a = sum (map fromEnum (map isSuccess a))

-- used to replace multiple tokens with different parameters
skipParameter :: Token -> Token
skipParameter (IDENTIFIER s)        = IDENTIFIER ""
skipParameter (BOOLEAN_LITERAL c)   = BOOLEAN_LITERAL True
skipParameter (CHARACTER_LITERAL c) = CHARACTER_LITERAL 'a'
skipParameter (INTEGER_LITERAL c)   = INTEGER_LITERAL 0
skipParameter a                     = a

tokenCovering :: [TestUnit] -> Int
tokenCovering a = length (nub (map (\a -> skipParameter a) (foldr (++) [] (map (\a -> getLexerRealToken a) a)))) -- get unique tokens used


lexTests :: [TestUnit]
lexTests = [(LexerUnit "EmptyClass" emptyTokens),
            (LexerUnit "InstanzVariable" instanzVariableTokens),
            (LexerUnit "ClassAssign" classAssignTokens),
            (LexerUnit "ClassMethods" classMethodTokens),
            (LexerUnit "ForLoop" forLoopTokens),
            (LexerUnit "LocalVariable" localVariableTokens),
            (LexerUnit "SimpleIf" simpleIfTokens),
            (LexerUnit "WhileLoop" whileLoopTokens),
            (LexerUnit "WhileLoopCondition" whileLoopConditionTokens),
            (LexerUnit "Arithmetic" arithmeticTokens),
            (LexerUnit "LogicOperations" logicOperationsTokens),
            (LexerUnit "BitWiseOperation" bitWiseOperationTokens)
           ]

main = do
       putStrLn "Lexer-Tests"

       putStrLn "-------------------------"
       mapM_ putStrLn (runTests lexTests)
       putStrLn ""
       putStrLn ("\x1b[36mTokencoverage: " ++ (show (tokenCovering lexTests)) ++ "/" ++ (show (length Lexer.Token.all_tokens)) ++ " (" ++ (show (ceiling ((fromIntegral (tokenCovering lexTests)) / (fromIntegral (length Lexer.Token.all_tokens)) * 100))) ++ "%) \x1b[0m ")
       putStrLn ""

       putStrLn "Parser-Tests"
       putStrLn "-------------------------"

       putStrLn ""

       putStrLn ("\x1b[36mTestresults: " ++ (show (numberOfSuccess lexTests)) ++ "/" ++ (show (length lexTests)) ++ " (" ++ (show (ceiling ((fromIntegral (numberOfSuccess lexTests)) / (fromIntegral (length lexTests)) * 100))) ++ "%) passed \x1b[0m ")





