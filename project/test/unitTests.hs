module Main (module Main) where

import           Arithmetic.Steps
import           BitWiseOperation.Steps
import           ClassAssign.Steps
import           ClassMethods.Steps
import           DoWhile.Steps
import           EmptyClass.Steps
import           ForLoop.Steps
import           InstanzVariable.Steps
import           LocalVariable.Steps
import           LogicOperations.Steps
import           NewClass.Steps
import           ShortIf.Steps
import           SimpleIf.Steps
import           SwitchCase.Steps
import           Utils.SUnit
import           WhileLoop.Steps
import           WhileLoopCondition.Steps

lexTests :: [TestUnit]
lexTests = [LexerUnit "EmptyClass" emptyTokens,
            LexerUnit "InstanzVariable" instanzVariableTokens,
            LexerUnit "ClassAssign" classAssignTokens,
            LexerUnit "ClassMethods" classMethodTokens,
            LexerUnit "ForLoop" forLoopTokens,
            LexerUnit "LocalVariable" localVariableTokens,
            LexerUnit "SimpleIf" simpleIfTokens,
            LexerUnit "ShortIf" shortIfTokens,
            LexerUnit "SwitchCase" switchCaseTokens,
            LexerUnit "WhileLoop" whileLoopTokens,
            LexerUnit "WhileLoopCondition" whileLoopConditionTokens,
            LexerUnit "DoWhile" doWhileTokens,
            LexerUnit "Arithmetic" arithmeticTokens,
            LexerUnit "LogicOperations" logicOperationsTokens,
            LexerUnit "BitWiseOperation" bitWiseOperationTokens,
            LexerUnit "NewClass" newClassTokens
           ]


parserTests :: [TestUnit]
parserTests = [ParserUnit "EmptyClass" emptyABS,
               ParserUnit "InstanzVariable" instanzVariableABS,
               ParserUnit "ClassAssign" classAssignABS,
               ParserUnit "ClassMethods" classMethodsABS,
               ParserUnit "ForLoop" forLoopABS,
               ParserUnit "LocalVariable" localVariableABS,
               ParserUnit "SimpleIf" simpleIfABS,
               ParserUnit "ShortIf" shortIfABS,
               ParserUnit "SwitchCase" switchCaseABS,
               ParserUnit "WhileLoop" whileLoopABS,
               ParserUnit "WhileLoopCondition" whileLoopConditionABS,
               ParserUnit "DoWhile" doWhileABS,
               ParserUnit "Arithmetic" emptyABS,
               ParserUnit "LogicOperations" logicOperationsABS,
               ParserUnit "BitWiseOperation" bitWiseOperationABS,
               ParserUnit "NewClass" newClassABS
               ]

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

