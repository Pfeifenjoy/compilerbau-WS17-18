module Main (module Main) where
import           UnitTests.LexTests
import           UnitTests.ParserTests
import           UnitTests.TypeTests
import           Utils.SUnit

allTests :: [TestUnit]
allTests = lexTests ++ parserTests ++ typeTests

main :: IO()
main = do
          putStrLn "Lexer-Tests"

          putStrLn "-------------------------"
          mapM_ (>>= putStrLn) (evalTests lexTests)
          putStrLn ""
          putStrLn (color Blue ("Tokencoverage: " ++ show (tokenCovering lexTests) ++ "/" ++ show (length all_tokens) ++ " (" ++ show (intDivisionPercentage (tokenCovering lexTests) (length all_tokens)) ++ "%)"))
          putStrLn ""

          putStrLn "Parser-Tests"
          putStrLn "-------------------------"
          mapM_ (>>= putStrLn) (evalTests parserTests)

          putStrLn ""

          putStrLn "TypeChecker-Tests"
          putStrLn "-------------------------"
          mapM_ (>>= putStrLn) (evalTests typeTests)

          putStrLn (color Blue ("Testresults: " ++ show (numberOfSuccess allTests) ++ "/" ++ show (length allTests) ++ " (" ++ show (intDivisionPercentage (numberOfSuccess allTests) (length allTests)) ++ "%) passed"))

