module Main (module Main) where
import           UnitTests.LexTests
import           UnitTests.ParserTests
import           UnitTests.TypeTests
import           Utils.SUnit

allTests :: [TestUnit]
allTests = lexTests ++ parserTests ++ typeTests

testResults :: [TestUnit] -> IO()
testResults tests = putStrLn (color Blue ("Testresults: " ++ show (numberOfSuccess tests) ++ "/" ++ show (length tests) ++ " (" ++ show (intDivisionPercentage (numberOfSuccess tests) (length tests)) ++ "%) passed"))


main :: IO()
main = do
          putStrLn "Lexer-Tests"

          putStrLn "-------------------------"
          mapM_ (>>= putStrLn) (evalTests lexTests)
          putStrLn ""
          putStrLn (color Blue ("Tokencoverage: " ++ show (tokenCovering lexTests) ++ "/" ++ show (length all_tokens) ++ " (" ++ show (intDivisionPercentage (tokenCovering lexTests) (length all_tokens)) ++ "%)"))
          putStrLn ""
          testResults lexTests
          putStrLn ""

          putStrLn "Parser-Tests"
          putStrLn "-------------------------"
          mapM_ (>>= putStrLn) (evalTests parserTests)
          putStrLn ""
          testResults parserTests
          putStrLn ""

          putStrLn "TypeChecker-Tests"
          putStrLn "-------------------------"
          mapM_ (>>= putStrLn) (evalTests typeTests)
          putStrLn ""
          testResults typeTests
          putStrLn ""

          putStrLn (color Blue ("All tests: " ++ show (numberOfSuccess allTests) ++ "/" ++ show (length allTests) ++ " (" ++ show (intDivisionPercentage (numberOfSuccess allTests) (length allTests)) ++ "%) passed"))

