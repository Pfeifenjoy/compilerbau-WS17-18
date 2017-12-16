module Main where

import Data.List
import Lexer.Token
import Lexer
import System.Directory
import EmptyClass.Steps
import InstanzVariable.Steps
import ClassAssign.Steps
import ClassMethods.Steps
import ForLoop.Steps
import LocalVariable.Steps
import SimpleIf.Steps
import WhileLoop.Steps
import WhileLoopCondition.Steps
import Arithmetic.Steps
import LogicOperations.Steps
import BitWiseOperation.Steps

-- data TestUnit = LexerUnit String [Token] -- TestName, TestTokens
--                 deriving(Eq, Show)
-- 
-- getLexerName :: TestUnit -> String
-- getLexerName (LexerUnit name testToken) = name
-- 
-- getLexerTestToken :: TestUnit -> [Token]
-- getLexerTestToken (LexerUnit name testToken) = testToken
-- 
-- getLexerRealToken :: TestUnit -> [Token]
-- getLexerRealToken (LexerUnit name testToken) = Lexer.lex (concat ["./test/", name, "/Class.java"])
-- 
-- 
-- runTest :: TestUnit -> String
-- runTest (LexerUnit name a) = let b = Lexer.lex (concat ["./test/", name, "/Class.java"])
--                              in 
--                              if a == b
--                                then concat ["\x1b[32m", "Lexer: [", name, "] passed", "\x1b[0m"]
--                                else concat ["\x1b[35m", "Lexer: [", name, "] failed", "\x1b[0m", 
--                                            "\n\t \x1b[36m expected: \x1b[0m ", (show a), 
--                                            "\n\t \x1b[36m got: \x1b[0m ", (show b),
--                                            "\n\t \x1b[36m difference: \x1b[0m", (show (nub (foldr (++) [] [a \\ b, b \\a])))]                                        
-- runTests :: [TestUnit] -> [String]
-- runTests a = map runTest a
-- 
-- -- checks whether a test is a success or not
-- isSuccess :: TestUnit -> Bool
-- isSuccess (LexerUnit name a) = a == (Lexer.lex (concat ["./test/", name, "/Class.java"]))
-- 
-- numberOfSuccess :: [TestUnit] -> Int
-- numberOfSuccess a = sum (map fromEnum (map isSuccess a))
-- 
-- -- used to replace multiple tokens with different parameters
-- skipParameter :: Token -> Token
-- skipParameter (IDENTIFIER s) = IDENTIFIER ""
-- skipParameter (BOOLEAN_LITERAL c) = BOOLEAN_LITERAL True
-- skipParameter (CHARACTER_LITERAL c) = CHARACTER_LITERAL 'a'
-- skipParameter (INTEGER_LITERAL c) = INTEGER_LITERAL 0
-- skipParameter a = a
-- 
-- tokenCovering :: [TestUnit] -> Int
-- tokenCovering a = length (nub (map (\a -> skipParameter a) (foldr (++) [] (map (\a -> getLexerRealToken a) a)))) -- get unique tokens used
--                       
-- 
-- lexTests :: [TestUnit]
-- lexTests = [(LexerUnit "EmptyClass" emptyTokens),
--             (LexerUnit "InstanzVariable" instanzVariableTokens),
--             (LexerUnit "ClassAssign" classAssignTokens),
--             (LexerUnit "ClassMethods" classMethodTokens),
--             (LexerUnit "ForLoop" forLoopTokens),
--             (LexerUnit "LocalVariable" localVariableTokens),
--             (LexerUnit "SimpleIf" simpleIfTokens),
--             (LexerUnit "WhileLoop" whileLoopTokens),
--             (LexerUnit "WhileLoopCondition" whileLoopConditionTokens),
--             (LexerUnit "Arithmetic" arithmeticTokens),
--             (LexerUnit "LogicOperations" logicOperationsTokens),
--             (LexerUnit "BitWiseOperation" bitWiseOperationTokens)
--            ]
-- 
-- main = do
--     mapM_ putStrLn (runTests lexTests)
--     putStrLn $ "Tokencoverage: " ++ (show (tokenCovering lexTests)) ++
--         "out of " ++ (show (length Lexer.Token.all_tokens))
--     putStrLn ""
--     putStrLn $ (show (numberOfSuccess lexTests)) ++ " Tests passed."


data TestCase
    = TestCase String [Token] -- name, expectedTokens

getName :: TestCase -> String
getName (TestCase name _) = name

getTokens :: TestCase -> [Token]
getTokens (TestCase _ tokens) = tokens

readTokens :: String -> IO [Token]
readTokens raw = return $ Lexer.lex raw

getPath :: String -> String
getPath name = "test/" ++ name ++ "/Class.java"

readTest :: String -> IO String
readTest name = readFile $ getPath name

data Color
    = Green
    | Purple
    | Blue

color :: Color -> String -> String
color Green text    = "\x1b[32m" ++ text ++ "\x1b[0m"
color Purple text   = "\x1b[35m" ++ text ++ "\x1b[0m"
color Blue text     = "\x1b[36m" ++ text ++ "\x1b[0m"

evalTokens :: TestCase -> [Token] -> String
evalTokens (TestCase name expectedTokens) tokens = if tokens == expectedTokens
      then color Green ("Lexer: [" ++ name ++ "] passed")
      else color Purple ("Lexer: [" ++ name ++ "] failed" ++ "\n\t")
        ++ color Blue (
            "expected:" ++ (show expectedTokens) ++ "\n\t"
            ++ "got:" ++ (show tokens) ++ "\n\t"
            ++ "difference:" ++ (show (nub (foldr (++) [] [expectedTokens \\ tokens, tokens \\expectedTokens])))
        )

run :: TestCase -> IO String
run testCase = do
    raw <- readTest $ getName testCase
    tokens <- readTokens raw
    return $ evalTokens testCase tokens

testCases :: [TestCase]
testCases = [
        (TestCase "EmptyClass" emptyTokens),
        (TestCase "InstanzVariable" instanzVariableTokens),
        (TestCase "ClassAssign" classAssignTokens),
        (TestCase "ClassMethods" classMethodTokens),
        (TestCase "ForLoop" forLoopTokens),
        (TestCase "LocalVariable" localVariableTokens),
        (TestCase "SimpleIf" simpleIfTokens),
        (TestCase "WhileLoop" whileLoopTokens),
        (TestCase "WhileLoopCondition" whileLoopConditionTokens),
        (TestCase "Arithmetic" arithmeticTokens),
        (TestCase "LogicOperations" logicOperationsTokens),
        (TestCase "BitWiseOperation" bitWiseOperationTokens)
    ]

concatIOString :: IO String -> IO String -> IO String
concatIOString a b = do
    a' <- a
    b' <- b
    return $ a' ++ b'

addNewLine :: IO String -> IO String
addNewLine text = do
    text' <- text
    return (text' ++ "\n")

formatResults :: [IO String] -> IO String
formatResults results = foldr concatIOString (return "") $ map addNewLine results

runAll :: [TestCase] -> IO String
runAll tests = formatResults $ map run testCases

main :: IO ()
main = do
    result <- runAll testCases
    putStr result
