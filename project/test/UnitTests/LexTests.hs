module UnitTests.LexTests (module UnitTests.LexTests) where

import           Correct.BitWiseOperation.Steps
import           Correct.ClassAssign.Steps
import           Correct.ClassMethods.Steps
import           Correct.DoWhile.Steps
import           Correct.EmptyClass.Steps
import           Correct.ForLoop.Steps
import           Correct.InstanceOf.Steps
import           Correct.InstanzVariable.Steps
import           Correct.LocalVariable.Steps
import           Correct.LogicOperations.Steps
import           Correct.LogicOperations2.Steps
import           Correct.MethodCall.Steps
import           Correct.NewClass.Steps
import           Correct.ShortIf.Steps
import           Correct.SimpleIf.Steps
import           Correct.SwitchCase.Steps
import           Correct.WhileLoop.Steps
import           Correct.WhileLoopCondition.Steps
import           Utils.SUnit
import           Wrong.Syntax.Arithmetic.Steps

lexTests :: [TestUnit]
lexTests = [LexerUnit "Correct/EmptyClass" emptyTokens,
            LexerUnit "Correct/InstanzVariable" instanzVariableTokens,
            LexerUnit "Correct/ClassAssign" classAssignTokens,
            LexerUnit "Correct/ClassMethods" classMethodTokens,
            LexerUnit "Correct/ForLoop" forLoopTokens,
            LexerUnit "Correct/LocalVariable" localVariableTokens,
            LexerUnit "Correct/SimpleIf" simpleIfTokens,
            LexerUnit "Correct/ShortIf" shortIfTokens,
            LexerUnit "Correct/SwitchCase" switchCaseTokens,
            LexerUnit "Correct/WhileLoop" whileLoopTokens,
            LexerUnit "Correct/WhileLoopCondition" whileLoopConditionTokens,
            LexerUnit "Correct/DoWhile" doWhileTokens,
            LexerUnit "Correct/LogicOperations" logicOperationsTokens,
            LexerUnit "Correct/LogicOperations2" logicOperations2Tokens,
            LexerUnit "Correct/BitWiseOperation" bitWiseOperationTokens,
            LexerUnit "Correct/NewClass" newClassTokens,
            LexerUnit "Correct/InstanceOf" instanceOfTokens,
            LexerUnit "Correct/MethodCall" methodCallTokens,
            LexerUnit "Wrong/Syntax/Arithmetic" arithmeticTokens
            ]
