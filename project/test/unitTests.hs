module Main (module Main) where

import           ABSTree
import           Arithmetic.Steps
import           BitWiseOperation.Steps
import           ClassAssign.Steps
import           ClassMethods.Steps
import           Control.Exception
import           Control.Monad
import           Data.List
import           EmptyClass.Steps
import           ForLoop.Steps
import           InstanzVariable.Steps
import           Lexer
import           Lexer.Token
import           LocalVariable.Steps
import           LogicOperations.Steps
import           Parser
import           SimpleIf.Steps
import           System.Directory
import           System.IO.Unsafe
import           WhileLoop.Steps
import           WhileLoopCondition.Steps


data TestUnit = LexerUnit String [Token] -- TestName, TestTokens
              | ParserUnit String [Class] -- Testname, TestClasses, fromTokens
                deriving(Eq, Show)

data Color
    = Green
    | Purple
    | Blue
    | Red

color :: Color -> String -> String
color Green text  = "\x1b[32m" ++ text ++ "\x1b[0m"
color Purple text = "\x1b[35m" ++ text ++ "\x1b[0m"
color Blue text   = "\x1b[36m" ++ text ++ "\x1b[0m"
color Red text    = "\x1b[31m" ++ text ++ "\x1b[0m"

getLexerName :: TestUnit -> String
getLexerName (LexerUnit name testToken) = name

getLexerTestToken :: TestUnit -> [Token]
getLexerTestToken (LexerUnit name testToken) = testToken

getLexerRealToken :: TestUnit -> [Token]
getLexerRealToken (LexerUnit name testToken) = readTokens name

readTokens :: String -> [Token]
readTokens s = Lexer.lex (unsafePerformIO . readFile $ ("./test/" ++ s ++ "/Class.java"))

runTest :: TestUnit -> IO Bool
runTest (LexerUnit name expectedTokens) = do
                                              result <- try (evaluate (readTokens name)) :: IO (Either SomeException [Token])
                                              case result of
                                                Left ex -> return False
                                                Right val -> return (val == expectedTokens)

runTest (ParserUnit name expectedClass) = do
                                            result <- try (evaluate (Parser.parse (readTokens name))) :: IO (Either SomeException [Class])
                                            case result of
                                              Left ex   -> return False
                                              Right val -> return (val == expectedClass)


evalTest :: TestUnit -> IO String
evalTest (LexerUnit name expectedTokens) = do
                                               result <- try (evaluate (readTokens name)) :: IO (Either SomeException [Token])
                                               case result of
                                                Left ex ->  return (color Red ("Lexer: [" ++ name ++ "] failed with exception: ") ++ show ex)
                                                Right lexerToken -> if lexerToken == expectedTokens
                                                then
                                                  return (color Green ("Lexer: [" ++ name ++ "] passed"))
                                                else
                                                  return (color Purple ("Lexer: [" ++ name ++ "] failed" ++ "\n\t") ++
                                                          color Blue "expected:" ++ show expectedTokens ++ "\n\t" ++
                                                          color Blue "got:" ++ show lexerToken ++ "\n\t" ++
                                                          color Blue "difference:" ++ show (nub ((expectedTokens \\ lexerToken) ++ (lexerToken \\ expectedTokens))))



evalTest (ParserUnit name expectedClass) = do
                                               result <- try (evaluate (Parser.parse (readTokens name))) :: IO (Either SomeException [Class])
                                               case result of
                                                Left ex ->  return (color Red ("Parser: [" ++ name ++ "] failed with exception: ")  ++ show ex)
                                                Right parserClass -> if parserClass == expectedClass
                                                then
                                                  return (color Green ("Parser: [" ++ name ++ "] passed"))
                                                else
                                                  return (color Purple ("Parser: [" ++ name ++ "] failed" ++ "\n\t") ++
                                                          color Blue "expected:" ++ show expectedClass ++ "\n\t" ++
                                                          color Blue "got:" ++ show parserClass ++ "\n\t" ++
                                                          color Blue "difference:" ++ show (nub ((expectedClass \\ parserClass) ++ (parserClass \\ expectedClass))))


runTests :: [TestUnit] -> [IO Bool]
runTests = map runTest

evalTests :: [TestUnit] -> [IO String]
evalTests = map evalTest

numberOfSuccess :: [TestUnit] -> Int
numberOfSuccess a = sum (map ((\ a -> if a then 1 else 0) . unsafePerformIO) (runTests a))

-- used to replace multiple tokens with different parameters
skipParameter :: Token -> Token
skipParameter (IDENTIFIER s)        = IDENTIFIER ""
skipParameter (BOOLEAN_LITERAL c)   = BOOLEAN_LITERAL True
skipParameter (CHARACTER_LITERAL c) = CHARACTER_LITERAL 'a'
skipParameter (INTEGER_LITERAL c)   = INTEGER_LITERAL 0
skipParameter a                     = a

tokenCovering :: [TestUnit] -> Int
tokenCovering a = length (nub (map skipParameter (foldr ((++) . getLexerRealToken) [] a))) -- get unique tokens used


lexTests :: [TestUnit]
lexTests = [LexerUnit "EmptyClass" emptyTokens,
            LexerUnit "InstanzVariable" instanzVariableTokens,
            LexerUnit "ClassAssign" classAssignTokens,
            LexerUnit "ClassMethods" classMethodTokens,
            LexerUnit "ForLoop" forLoopTokens,
            LexerUnit "LocalVariable" localVariableTokens,
            LexerUnit "SimpleIf" simpleIfTokens,
            LexerUnit "WhileLoop" whileLoopTokens,
            LexerUnit "WhileLoopCondition" whileLoopConditionTokens,
            LexerUnit "Arithmetic" arithmeticTokens,
            LexerUnit "LogicOperations" logicOperationsTokens,
            LexerUnit "BitWiseOperation" bitWiseOperationTokens
           ]


parserTests :: [TestUnit]
parserTests = [ParserUnit "EmptyClass" emptyABS,
               ParserUnit "InstanzVariable" instanzVariableABS,
               ParserUnit "ClassAssign" emptyABS,
               ParserUnit "Arithmetic" emptyABS
               ]

allTests :: [TestUnit]
allTests = lexTests ++ parserTests

main = do
          putStrLn "Lexer-Tests"

          putStrLn "-------------------------"
          mapM_ (>>= putStrLn) (evalTests lexTests)
          putStrLn ""
          putStrLn (color Blue ("Tokencoverage: " ++ show (tokenCovering lexTests) ++ "/" ++ show (length Lexer.Token.all_tokens) ++ " (" ++ show (ceiling (fromIntegral (tokenCovering lexTests) / fromIntegral (length Lexer.Token.all_tokens) * 100)) ++ "%)"))
          putStrLn ""

          putStrLn "Parser-Tests"
          putStrLn "-------------------------"
          mapM_ (>>= putStrLn) (evalTests parserTests)

          putStrLn ""

          putStrLn (color Blue ("Testresults: " ++ show (numberOfSuccess allTests) ++ "/" ++ show (length allTests) ++ " (" ++ show (ceiling (fromIntegral (numberOfSuccess allTests) / fromIntegral (length allTests) * 100)) ++ "%) passed"))

