module UnitTests.TypeTests (module UnitTests.TypeTests) where

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
import           Correct.MethodCall.Steps
import           Correct.NewClass.Steps
import           Correct.ShortIf.Steps
import           Correct.SimpleIf.Steps
import           Correct.SwitchCase.Steps
import           Correct.WhileLoop.Steps
import           Correct.WhileLoopCondition.Steps
import           Utils.SUnit

typeTests :: [TestUnit]
typeTests = [TypeUnit "Correct/EmptyClass" emptyTypedABS,
             TypeUnit "Correct/InstanzVariable" instanzVariableTypedABS,
             TypeUnit "Correct/LocalVariable" localVariableTypedABS,
             TypeUnit "Correct/ClassAssign" classAssignTypedABS
            ]
