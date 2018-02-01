module UnitTests.TypeTests (module UnitTests.TypeTests) where

import           Correct.BitWiseOperation.Steps
import           Correct.ClassAssign.Steps
import           Correct.ClassMethods.Steps
import           Correct.DoWhile.Steps
import           Correct.EmptyClass.Steps
import           Correct.EndlessForLoop.Steps
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
import Correct.OperatorOverloading.Steps

typeTests :: [TestUnit]
typeTests = [TypeUnit "Correct/EmptyClass" emptyTypedABS,
             TypeUnit "Correct/InstanzVariable" instanzVariableTypedABS,
             TypeUnit "Correct/ClassAssign" classAssignTypedABS,
             TypeUnit "Correct/ClassMethods" classMethodsTypedABS,
             TypeUnit "Correct/OperatorOverloading" operatorOverloadingTypedABS,
             TypeUnit "Correct/ForLoop" forLoopTypedABS,
             TypeUnit "Correct/EndlessForLoop" endlessForLoopTypedABS,
             TypeUnit "Correct/LocalVariable" localVariableTypedABS,
             TypeUnit "Correct/SimpleIf" simpleIfTypedABS,
             TypeUnit "Correct/ShortIf" shortIfTypedABS,
             -- TypeUnit "Correct/SwitchCase" emptyABS,
             TypeUnit "Correct/WhileLoop" whileLoopTypedABS,
             TypeUnit "Correct/WhileLoopCondition" whileLoopConditionTypedABS,
             TypeUnit "Correct/DoWhile" doWhileTypedABS,
             TypeUnit "Correct/LogicOperations" logicOperationsTypedABS,
             TypeUnit "Correct/LogicOperations2" logicOperations2TypedABS,
             TypeUnit "Correct/BitWiseOperation" bitWiseOperationTypedABS,
             TypeUnit "Correct/NewClass" newClassTypedABS,
             TypeUnit "Correct/InstanceOf" instanceOfTypedABS,
             TypeUnit "Correct/MethodCall" methodCallTypedABS--,



            ]
