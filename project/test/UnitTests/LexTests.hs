module UnitTests.LexTests (module UnitTests.LexTests) where

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
