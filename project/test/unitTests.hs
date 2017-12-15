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

data TestUnit = LexerUnit String [Token] [Token] -- TestName, TestTokens, FileTokens
                deriving(Eq, Show)

getLexerName :: TestUnit -> String
getLexerName (LexerUnit name testToken realToken) = name

getLexerTestToken :: TestUnit -> [Token]
getLexerTestToken (LexerUnit name testToken realToken) = testToken

getLexerRealToken :: TestUnit -> [Token]
getLexerRealToken (LexerUnit name testToken realToken) = realToken

runTest :: TestUnit -> String
runTest (LexerUnit name a b) = if a == b
                               then concat ["\x1b[32m", "Lexer: [", name, "] passed", "\x1b[0m"]
                               else concat ["\x1b[35m", "Lexer: [", name, "] failed", "\x1b[0m", 
                                           "\n\t \x1b[36m expected: \x1b[0m ", (show a), 
                                           "\n\t \x1b[36m got: \x1b[0m ", (show b),
                                           "\n\t \x1b[36m difference: \x1b[0m", (show (a \\ b))]                                        
runTests :: [TestUnit] -> [String]
runTests a = map runTest a

isSuccess :: TestUnit -> Bool
isSuccess (LexerUnit name a b) = a == b

numberOfSuccess :: [TestUnit] -> Int
numberOfSuccess a = sum (map fromEnum (map isSuccess a))

-- used to replace multiple tokens with different parameters
skipParameter :: Token -> Token
skipParameter (IDENTIFIER s) = IDENTIFIER ""
skipParameter (BOOLEAN_LITERAL c) = BOOLEAN_LITERAL True
skipParameter (CHARACTER_LITERAL c) = CHARACTER_LITERAL 'a'
skipParameter (INTEGER_LITERAL c) = INTEGER_LITERAL 0
skipParameter a = a

tokenCovering :: [TestUnit] -> Int
tokenCovering a = length (nub (map (\a -> skipParameter a) (foldr (++) [] (map (\a -> getLexerRealToken a) a)))) -- get unique tokens used
                      

lexTests :: [TestUnit]
lexTests = [(LexerUnit "EmptyClass" emptyTokens (Lexer.lex "./test/EmptyClass/Class.java")),
            (LexerUnit "InstanzVariable" instanzVariableTokens (Lexer.lex "./test/InstanzVariable/Class.java")),
            (LexerUnit "ClassAssign" classAssignTokens (Lexer.lex "./test/ClassAssign/Class.java")),
            (LexerUnit "ClassMethods" classMethodTokens (Lexer.lex "./test/ClassMethods/Class.java")),
            (LexerUnit "ForLoop" forLoopTokens (Lexer.lex "./test/ForLoop/Class.java")),
            (LexerUnit "LocalVariable" localVariableTokens (Lexer.lex "./test/LocalVariable/Class.java")),
            (LexerUnit "SimpleIf" simpleIfTokens (Lexer.lex "./test/SimpleIf/Class.java")),
            (LexerUnit "WhileLoop" whileLoopTokens (Lexer.lex "./test/WhileLoop/Class.java")),
            (LexerUnit "WhileLoopCondition" whileLoopConditionTokens (Lexer.lex "./test/WhileLoopCondition/Class.java")),
            (LexerUnit "Arithmetic" arithmeticTokens (Lexer.lex "./test/Arithmetic/Class.java")),
            (LexerUnit "LogicOperations" logicOperationsTokens (Lexer.lex "./test/LogicOperations/Class.java")),
            (LexerUnit "BitWiseOperation" bitWiseOperationTokens (Lexer.lex "./test/BitWiseOperation/Class.java"))
           ]

main = do
       mapM_ putStrLn (runTests lexTests)
       putStrLn ("\x1b[36mTokencoverage: " ++ show (tokenCovering lexTests) ++ " out of " ++ (show (length Lexer.Token.all_tokens)) ++ " \x1b[0m ")
       putStrLn ""
       putStrLn ("\x1b[36m" ++ (show (numberOfSuccess lexTests)) ++ " out of " ++ (show (length lexTests)) ++ " Tests passed \x1b[0m ")
       
 

         
