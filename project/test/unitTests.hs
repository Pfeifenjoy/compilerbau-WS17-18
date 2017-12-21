module Main (module Main) where
import           UnitTests.LexTests
import           UnitTests.ParserTests
import           Utils.SUnit

allTests :: [TestUnit]
allTests = lexTests ++ parserTests

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

          putStrLn (color Blue ("Testresults: " ++ show (numberOfSuccess allTests) ++ "/" ++ show (length allTests) ++ " (" ++ show (intDivisionPercentage (numberOfSuccess allTests) (length allTests)) ++ "%) passed"))

