module Main (module Main) where
import           UnitTests.LexTests
import           UnitTests.ParserTests
import           Utils.SUnit

allTests :: [TestUnit]
allTests = lexTests ++ parserTests

main = do
          putStrLn "Lexer-Tests"

          putStrLn "-------------------------"
          mapM_ (>>= putStrLn) (evalTests lexTests)
          putStrLn ""
          putStrLn (color Blue ("Tokencoverage: " ++ show (tokenCovering lexTests) ++ "/" ++ show (length all_tokens) ++ " (" ++ show (ceiling (fromIntegral (tokenCovering lexTests) / fromIntegral (length all_tokens) * 100)) ++ "%)"))
          putStrLn ""

          putStrLn "Parser-Tests"
          putStrLn "-------------------------"
          mapM_ (>>= putStrLn) (evalTests parserTests)

          putStrLn ""

          putStrLn (color Blue ("Testresults: " ++ show (numberOfSuccess allTests) ++ "/" ++ show (length allTests) ++ " (" ++ show (ceiling (fromIntegral (numberOfSuccess allTests) / fromIntegral (length allTests) * 100)) ++ "%) passed"))

