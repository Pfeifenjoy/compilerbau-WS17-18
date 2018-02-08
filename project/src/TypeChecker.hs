module TypeChecker where

import ABSTree
import Data.Maybe 
import qualified Data.Map as Map

-- local variable table
type VarName = String
type MethodName = String
type FieldName = String
type Operator = String
type VisibleClassList = [Class]
type LocVarTable = Map.Map VarName Type
type FieldDecs = [FieldDecl]
type VarDecs = [VariableDecl]
type MethodDecs = [MethodDecl]
type SwitchCases = [SwitchCase]


-- main typecheck function
checkTypes :: Program -> Program
checkTypes classList = 
    map (\currentClass -> checkClass currentClass classList) classList


-- typecheck a single class
checkClass :: Class -> VisibleClassList -> Class
checkClass (Class classType fieldDecs methodDecs) visibleClassList =
    let (typedFieldDecs, locVarTable) =
            typeCheckFieldDecs fieldDecs classType visibleClassList
        typedMethodDecs = 
            typeCheckMethodDecs methodDecs locVarTable visibleClassList        
    in (Class classType typedFieldDecs typedMethodDecs)


-- typecheck field declarations and generate LocVarTable in the process
typeCheckFieldDecs :: FieldDecs 
                      -> Type 
                      -> VisibleClassList 
                      -> (FieldDecs, LocVarTable)
typeCheckFieldDecs fieldDecs thisType visibleClassList =
    foldl foldFieldDec ([], (Map.singleton "this" thisType)) fieldDecs
        where
            foldFieldDec (currentTypedFieldDecs, currentLocVarTable)
                         (FieldDecl varDecs visibility isStatic) =
                let (typedVarDecs, updatedLocVarTable) =
                        foldl foldVarDec ([], currentLocVarTable) varDecs
                    nextTypedFieldDec = 
                        (FieldDecl typedVarDecs visibility isStatic)
                    updatedTypedFieldDecs = 
                        currentTypedFieldDecs ++ [nextTypedFieldDec]
                in (updatedTypedFieldDecs, updatedLocVarTable)
            
            foldVarDec (currentTypedVarDecs, currentLocVarTable)
                       (VariableDecl varName varType isFinal maybeInitExpr) =
                let updatedLocVarTable = 
                        Map.insert varName varType currentLocVarTable
                    typedMaybeInitExpr =
                        fmap (\initValExpr -> typeCheckExpr initValExpr
                                                            currentLocVarTable
                                                            visibleClassList)
                             maybeInitExpr
                    nextTypedVarDec = VariableDecl varName 
                                                   varType 
                                                   isFinal 
                                                   typedMaybeInitExpr
                    updatedTypedVarDecs =
                        currentTypedVarDecs ++ [nextTypedVarDec]
                in case typedMaybeInitExpr of
                            Nothing -> 
                                (updatedTypedVarDecs, updatedLocVarTable)
                            Just (TypedExpr _ initExprType) ->
                                if initExprType == varType
                                then (updatedTypedVarDecs, updatedLocVarTable)
                                else error $ "Initialization of "
                                           ++ varType ++ " variable "
                                           ++ varName ++ " with type "
                                           ++ initExprType


-- typecheck class method declarations
typeCheckMethodDecs :: MethodDecs 
                       -> LocVarTable 
                       -> VisibleClassList
                       -> MethodDecs
typeCheckMethodDecs methodDecs locVarTable visibleClassList =
    map (\method -> typeCheckMethod method locVarTable visibleClassList)
        methodDecs


-- typecheck a single class method
typeCheckMethod :: MethodDecl -> LocVarTable -> VisibleClassList -> MethodDecl
typeCheckMethod (MethodDecl name returnType argDecs body visibility isStatic)
                locVarTable
                visibleClassList =
    let argVarTable = 
            foldl (\currentArgVarTable -> 
                       \(ArgumentDecl argName argType _) ->
                           Map.insert argName argType currentArgVarTable)
                  Map.empty
                  argDecs
        shadowedLocVarTable = Map.union argVarTable locVarTable
        typedBody@(TypedStmt _ bodyType) =
            typeCheckStmt body shadowedLocVarTable visibleClassList
    in if (bodyType == returnType)
          || ((name == (fromJust $ Map.lookup "this" locVarTable))
              && bodyType == "void")
       then MethodDecl name returnType argDecs typedBody visibility isStatic
       else error $ "Bodytype " ++ bodyType ++ " and returnType "
                  ++ returnType ++ " of Function " ++ name 
                  ++ " do not match"
            

-- TYPECHECKING OF EXPRESSIONS:
typeCheckExpr :: Expr -> LocVarTable -> [Class] -> Expr
-- This 
typeCheckExpr This locVarTable visibleClassList =
    TypedExpr This (fromJust $ Map.lookup "this" locVarTable)
-- LocalOrFieldVar
typeCheckExpr expr@(LocalOrFieldVar varName) locVarTable visibleClassList = 
    case Map.lookup varName locVarTable of
        Just varType -> TypedExpr expr varType
        Nothing      -> error $ "Unknown variable " ++ varName ++ " encountered"
-- InstVar 
typeCheckExpr (InstVar instExpr instVarName) locVarTable visibleClassList =
    let typedInstExpr@(TypedExpr _ instExprType) =
            typeCheckExpr instExpr locVarTable visibleClassList
        thisType =
            fromJust $ Map.lookup "this" locVarTable
    in case classLookup instExprType visibleClassList of
           Nothing -> error $ "Class " ++ instExprType ++ " not found"
           Just instClass ->
               case classFieldLookup instVarName instClass thisType of
                   Nothing -> error $ "Class " ++ instExprType
                                      ++ " has no (visible) field "
                                      ++ instVarName
                   Just fieldType ->
                       TypedExpr (InstVar typedInstExpr instVarName)
                                 fieldType
-- Unary operators
typeCheckExpr (Unary operator operandExpr) locVarTable visibleClassList =
    let typedOperandExpr@(TypedExpr _ operandExprType) =
            typeCheckExpr operandExpr locVarTable visibleClassList
        possibleCombinations = [("!","boolean"),("+","int"),("-","int")
                               ,("++","int"),("--","int")]
    in if (operator, operandExprType) `elem` possibleCombinations
       then TypedExpr (Unary operator typedOperandExpr) operandExprType
       else error $ "Unary operator " ++ operator ++ " is not compatible with "
                    ++ "type " ++ operandExprType
-- Binary operators 
typeCheckExpr (Binary operator operandExprA operandExprB)
              locVarTable
              visibleClassList =
    let typedOperandExprA@(TypedExpr _ operandExprAType) =
            typeCheckExpr operandExprA locVarTable visibleClassList
        typedOperandExprB@(TypedExpr _ operandExprBType) =
            typeCheckExpr operandExprB locVarTable visibleClassList
        operandError = 
            error $ "Operator " ++ operator ++ " can not be applied to types "
                  ++ operandExprAType ++ " and " ++ operandExprBType                               
        resultType = 
            case (operator, operandExprAType, operandExprBType) of
                (op, "int", "int")
                    | op `elem` ["+", "-", "*", "/", "%", "&", "|", "^", "<<"
                                , ">>", ">>>"] -> "int"
                    | op `elem` ["<=",">=","<",">", "=="] -> "boolean"
                    | otherwise -> operandError 
                ("||", "boolean", "boolean") -> "boolean"
                ("&&", "boolean", "boolean") -> "boolean"
                (op, operA, operB) 
                    | op `elem` ["==","!="] && operA == operB -> operA
                    | otherwise -> operandError
    in TypedExpr (Binary operator typedOperandExprA typedOperandExprB)
                 resultType            
-- InstanceOf              
typeCheckExpr (InstanceOf instExpr proposedType) locVarTable visibleClassList =
    let typedInstExpr = typeCheckExpr instExpr locVarTable visibleClassList
    in TypedExpr (InstanceOf typedInstExpr proposedType) "boolean"
-- Ternary operator 
typeCheckExpr (Ternary operandExprA operandExprB operandExprC)
              locVarTable
              visibleClassList =
    let typedOperandExprA@(TypedExpr _ operandExprAType) =
            typeCheckExpr operandExprA locVarTable visibleClassList
        typedOperandExprB@(TypedExpr _ operandExprBType) =
            typeCheckExpr operandExprB locVarTable visibleClassList
        typedOperandExprC@(TypedExpr _ operandExprCType) =
            typeCheckExpr operandExprC locVarTable visibleClassList
    in if operandExprAType == "boolean"
       then TypedExpr (Ternary typedOperandExprA
                               typedOperandExprB
                               typedOperandExprC)
                      (propagateSuperType operandExprBType
                                          operandExprCType)
       else error "First expression of ternary operator must be a boolean"
-- Literals
typeCheckExpr expr@(BooleanLiteral _) _ _ = TypedExpr expr "boolean"
typeCheckExpr expr@(CharLiteral _)    _ _ = TypedExpr expr "char"
typeCheckExpr expr@(IntegerLiteral _) _ _ = TypedExpr expr "int"
-- JNull
typeCheckExpr JNull _ _ = TypedExpr JNull "void"
-- StatementExpressions
typeCheckExpr (StmtExprExpr stmtExpr) locVarTable visibleClassList = 
    let typedStmtExpr@(TypedStmtExpr _ stmtExprType) =
            typeCheckStmtExpr stmtExpr locVarTable visibleClassList
    in TypedExpr (StmtExprExpr typedStmtExpr) stmtExprType
-- Catching typechecks of typechecked expressions
typeCheckExpr (TypedExpr _ _) _ _ =
    error "Trying to typecheck an already typechecked expression"

    
-- TYPECHECKING OF EXPRESSION STATEMENTS:
typeCheckStmtExpr :: StmtExpr -> LocVarTable -> VisibleClassList -> StmtExpr
-- Assign
typeCheckStmtExpr (Assign leftValExpr rightValExpr) 
                  locVarTable 
                  visibleClassList =
    let typedLeftValExpr@(TypedExpr _ leftValExprType) =
            typeCheckExpr leftValExpr locVarTable visibleClassList
        typedRightValExpr@(TypedExpr _ rightValExprType) =
            typeCheckExpr rightValExpr locVarTable visibleClassList
    in if (leftValExprType == rightValExprType)
       then TypedStmtExpr (Assign typedLeftValExpr typedRightValExpr)
                          leftValExprType
       else error $ "Cannot assign " ++ rightValExprType ++ " to a variable "
                  ++ "of type " ++ leftValExprType 
-- New
typeCheckStmtExpr (New newClassName argExprs) locVarTable visibleClassList =
    let typedArgExprs = map (\argExpr -> typeCheckExpr argExpr
                                                       locVarTable
                                                       visibleClassList)
                            argExprs
        argExprsTypes =
            map (\(TypedExpr _ argExprType) -> argExprType) typedArgExprs
        thisType = 
            fromJust $ Map.lookup "this" locVarTable
    in case classLookup newClassName visibleClassList of
           Just newClass ->
               case methodLookup newClassName newClass thisType of
                   [] -> if argExprsTypes == []
                         then TypedStmtExpr (New newClassName typedArgExprs)
                                            newClassName
                         else error $ "Trying to call standard constructor with"
                                    ++ " arguments"
                   constructorDecs -> checkArgs constructorDecs
                       where
                           checkArgs ((MethodDecl _ retType argDecs _ _ _):cs) =
                               if (==) argExprsTypes
                                       (map (\(ArgumentDecl _ argType _) ->
                                                 argType)
                                       argDecs)
                               then TypedStmtExpr (New newClassName
                                                      typedArgExprs)
                                                  newClassName
                               else checkArgs cs
                           checkArgs [] =
                               error $ "Constructor with corresponding"
                                     ++ " arguments not found"
           Nothing -> error $ "Class " ++ newClassName ++ " could not be found"
-- MethodCall
typeCheckStmtExpr (MethodCall instExpr methodName argExprs)
                  locVarTable
                  visibleClassList =
    let typedInstExpr@(TypedExpr _ instExprType) =
            typeCheckExpr instExpr locVarTable visibleClassList
        typedArgExprs =
            map (\argExpr -> 
                     typeCheckExpr argExpr locVarTable visibleClassList)
                argExprs
        argExprsTypes =
            map (\(TypedExpr _ argExprType) -> argExprType) typedArgExprs
        thisType =
            fromJust $ Map.lookup "this" locVarTable
    in case classLookup instExprType visibleClassList of
           Just instClass -> 
               case methodLookup methodName instClass thisType of
                   [] -> error $ "Method " ++ methodName ++ " could not be "
                               ++ "found or is not visible"
                   methodDecs -> checkArgs methodDecs
                       where  
                           checkArgs ((MethodDecl _ retType argDecs _ _ _):cs) =
                               if (==) argExprsTypes
                                       (map (\(ArgumentDecl _ argType _) ->
                                                 argType)
                                       argDecs)
                               then TypedStmtExpr (MethodCall typedInstExpr
                                                              methodName
                                                              typedArgExprs)
                                                  retType
                               else checkArgs cs
                           checkArgs [] =
                               error $ "Method with corresponding"
                                     ++ " arguments not found" 
           Nothing -> error $ "Class " ++ instExprType ++ " could not be found"
-- Lazy Assignment
typeCheckStmtExpr (LazyAssign leftValExpr rightValExpr)
                  locVarTable
                  visibleClassList =
    let TypedStmtExpr (Assign typedLeftValExpr typedRightValExpr) assignType =
            typeCheckStmtExpr (Assign leftValExpr rightValExpr)
                              locVarTable
                              visibleClassList
    in TypedStmtExpr (LazyAssign typedLeftValExpr typedRightValExpr) assignType
-- Catching typechecks of typechecked expressions
typeCheckStmtExpr (TypedStmtExpr _ _) _ _ =
    error "Trying to typecheck an already typechecked statement expression"

    
-- TYPECHECKING STATEMENTS:
typeCheckStmt :: Stmt -> LocVarTable -> VisibleClassList -> Stmt
-- Block
typeCheckStmt (Block blockStmts) locVarTable visibleClassList =
    TypedStmt (Block typedBlockStmts) blockType
    where
        (typedBlockStmts, _, blockType) =
            foldl foldBlockSegment ([], locVarTable, "void") blockStmts
    
        foldBlockSegment (currentTypedBlockStmts
                         ,currentLocVarTable
                         ,currentBlockType)
                         nextBlockStmt =
            let (typedNextBlockStmt@(TypedStmt _ nextBlockType)
                 , updatedLocVarTable) = 
                    typeCheckStmtLocVarTransform nextBlockStmt 
                                                 currentLocVarTable
                                                 visibleClassList
                updatedTypedBlockStmts =
                    currentTypedBlockStmts ++ [typedNextBlockStmt]
                updatedBlockType =
                    propagateSuperType nextBlockType currentBlockType
            in (updatedTypedBlockStmts, updatedLocVarTable, updatedBlockType)
-- Return 
typeCheckStmt (Return returnExpr) locVarTable visibleClassList =
   let typedReturnExpr@(TypedExpr _ returnExprType) =
           typeCheckExpr returnExpr locVarTable visibleClassList
   in TypedStmt (Return typedReturnExpr) returnExprType
-- While loop
typeCheckStmt (While condExpr whileStmt) locVarTable visibleClassList =
   let typedCondExpr@(TypedExpr _ condExprType) =
           typeCheckExpr condExpr locVarTable visibleClassList
       typedWhileStmt@(TypedStmt _ whileStmtType) =
           typeCheckStmt whileStmt locVarTable visibleClassList
   in if (condExprType == "boolean")
      then TypedStmt (While typedCondExpr typedWhileStmt) whileStmtType
      else error "Conditional expression in while loop must be a boolean"
-- Do-While loop
typeCheckStmt (DoWhile condExpr doWhileExpr) locVarTable visibleClassList =
   let (TypedStmt (While typedCondExpr typedDoWhileExpr) doWhileExprType) =
           typeCheckStmt (While condExpr doWhileExpr)
                         locVarTable
                         visibleClassList
   in TypedStmt (DoWhile typedCondExpr typedDoWhileExpr) doWhileExprType
-- For loop
-- TODO: iterStmt cannot change locVarTable
typeCheckStmt (For initStmt condExpr iterStmt bodyStmt)
              locVarTable
              visibleClassList =
    let (typedInitStmt, updatedLocVarTable) =
            typeCheckStmtLocVarTransform initStmt
                                         locVarTable
                                         visibleClassList
        typedCondExpr@(TypedExpr _ condExprType) =
            typeCheckExpr condExpr updatedLocVarTable visibleClassList
        (typedIterStmt, updatedUpdatedLocVarTable) =
            typeCheckStmtLocVarTransform iterStmt
                                         updatedLocVarTable
                                         visibleClassList
        typedBodyStmt@(TypedStmt _ bodyStmtType) =
            typeCheckStmt bodyStmt updatedUpdatedLocVarTable visibleClassList
    in if condExprType == "boolean"
       then TypedStmt (For typedInitStmt 
                           typedCondExpr 
                           typedIterStmt
                           typedBodyStmt)
                      bodyStmtType
       else error "Conditional expression in for loop must have boolean type"
-- Break
typeCheckStmt Break _ _ = TypedStmt Break "void"
-- Continue
typeCheckStmt Continue _ _ = TypedStmt Continue "void"
-- If
typeCheckStmt (If condExpr thenStmt maybeElseStmt)
              locVarTable 
              visibleClassList =
    let typedCondExpr@(TypedExpr _ condExprType) =
            typeCheckExpr condExpr locVarTable visibleClassList
        typedThenStmt@(TypedStmt _ thenStmtType) =
            typeCheckStmt thenStmt locVarTable visibleClassList
        typedMaybeElseStmt =
            fmap (\elseStmt -> 
                      typeCheckStmt elseStmt locVarTable visibleClassList)
                 maybeElseStmt
    in if condExprType == "boolean"
       then TypedStmt (If typedCondExpr typedThenStmt typedMaybeElseStmt)
                      (case typedMaybeElseStmt of
                           Just (TypedStmt _ elseStmtType) ->
                               propagateSuperType thenStmtType elseStmtType
                           Nothing -> thenStmtType)
       else error "Conditional expression in if clause must have boolean type"
-- Switch
typeCheckStmt (Switch switchExpr switchCases maybeDefaultCaseStmts)
              locVarTable
              visibleClassList =
    let typedSwitchExpr@(TypedExpr _ switchExprType) =
            typeCheckExpr switchExpr locVarTable visibleClassList
        (typedSwitchCases, switchCasesType) =
            typeCheckSwitchCases switchCases 
                                 switchExprType
                                 locVarTable
                                 visibleClassList
        typedMaybeDefaultCaseStmtsAndType =
           fmap ((.) (\(TypedStmt (Block typedStmts) stmtsType) -> 
                          (typedStmts, stmtsType))
                     (\stmts -> 
                          typeCheckStmt (Block stmts) 
                                        locVarTable 
                                        visibleClassList))
                maybeDefaultCaseStmts
    in case typedMaybeDefaultCaseStmtsAndType of
           Nothing -> TypedStmt (Switch typedSwitchExpr 
                                        typedSwitchCases
                                        Nothing)
                                switchCasesType
           Just (typedDefaultCaseStmts, defaultCaseStmtsType)
               | defaultCaseStmtsType == switchCasesType ->
                     TypedStmt (Switch typedSwitchExpr
                                       typedSwitchCases
                                       (Just typedDefaultCaseStmts))
                               switchCasesType
               | otherwise ->
                     error $ "Cases and default case types do not match"
-- Statement Expressions
typeCheckStmt (StmtExprStmt stmtExpr) locVarTable visibleClassList =
    let typedStmtExpr@(TypedStmtExpr _ stmtExprType) =
            typeCheckStmtExpr stmtExpr locVarTable visibleClassList
    in TypedStmt (StmtExprStmt typedStmtExpr) "void"
typeCheckStmt (TypedStmt _ _) _ _ =
    error "Trying to typecheck an already typechecked statement"

              
-- typecheck statements and transform LocVarTable in the process
typeCheckStmtLocVarTransform :: Stmt
                                -> LocVarTable 
                                -> VisibleClassList 
                                -> (Stmt, LocVarTable)
typeCheckStmtLocVarTransform (LocalVarDecls varDecs)
                             locVarTable
                             visibleClassList =
    let (typedVarDecs, updatedLocVarTable) =
            typeCheckVarDecs varDecs locVarTable visibleClassList
    in (TypedStmt (LocalVarDecls typedVarDecs) "void", updatedLocVarTable)
typeCheckStmtLocVarTransform stmt locVarTable visibleClassList =
    (typeCheckStmt stmt locVarTable visibleClassList, locVarTable) 

-- HELPER FUNCTIONS:
-- typeCheck variable declarations and update LocVarTable in the process
typeCheckVarDecs :: VarDecs 
                    -> LocVarTable 
                    -> VisibleClassList 
                    -> (VarDecs, LocVarTable)
typeCheckVarDecs varDecs locVarTable visibleClassList =
    foldl foldVarDec ([], locVarTable) varDecs
        where 
            foldVarDec (currentTypedVarDecs, currentLocVarTable)
                       (VariableDecl varName varType isFinal maybeInitExpr) =
                let updatedLocVarTable =
                        if Map.member varName currentLocVarTable 
                        then error $ "Variable " ++ varName ++ " already"
                                   ++ " exists in scope"
                        else Map.insert varName varType currentLocVarTable
                    typedMaybeInitExpr =
                        fmap (\initValExpr -> typeCheckExpr initValExpr
                                                            currentLocVarTable
                                                            visibleClassList)
                             maybeInitExpr
                    nextTypedVarDec = VariableDecl varName 
                                                   varType 
                                                   isFinal 
                                                   typedMaybeInitExpr
                    updatedTypedVarDecs =
                        currentTypedVarDecs ++ [nextTypedVarDec]
                    
                in (updatedTypedVarDecs, updatedLocVarTable)

-- typecheck switch cases and determine their type
typeCheckSwitchCases :: SwitchCases 
                        -> Type 
                        -> LocVarTable 
                        -> VisibleClassList
                        -> (SwitchCases, Type)
typeCheckSwitchCases switchCases switchExprType locVarTable visibleClassList =
    let typedSwitchCasesAndSwitchCaseTypes =
            map (\(SwitchCase switchCaseExpr switchCaseStmts) ->
                     let typedSwitchCaseExpr@(TypedExpr _ switchCaseExprType) =
                             typeCheckExpr switchCaseExpr
                                           locVarTable
                                           visibleClassList
                         (TypedStmt (Block typedSwitchCaseStmts)
                                    switchCaseStmtsType) =
                             typeCheckStmt (Block switchCaseStmts)
                                           locVarTable
                                           visibleClassList
                     in if switchCaseExprType == "int"
                        then (SwitchCase typedSwitchCaseExpr
                                         typedSwitchCaseStmts
                             , switchCaseStmtsType)
                        else error "Case expression must me be an integer")
                switchCases
        (typedSwitchCases, switchCaseTypes) =
            unzip typedSwitchCasesAndSwitchCaseTypes
        switchCasesResultType = 
            foldr propagateSuperType "void" switchCaseTypes
    in (typedSwitchCases, switchCasesResultType)    


-- looks up a field in a class
classFieldLookup :: FieldName -> Class -> Type -> Maybe Type
classFieldLookup searchedfieldName (Class classType fieldDecs _) thisType  =
   fieldDecsLookup fieldDecs
       where
           fieldDecsLookup [] = Nothing
           fieldDecsLookup ((FieldDecl varDecs Public _):fs) =
               case varDecsLookup varDecs of
                        Nothing -> fieldDecsLookup fs
                        res -> res
           fieldDecsLookup ((FieldDecl varDecs Private isStatic):fs)
               | thisType == classType =
                     fieldDecsLookup $ (FieldDecl varDecs Public isStatic):fs
               | otherwise = fieldDecsLookup fs
           
           varDecsLookup [] = Nothing
           varDecsLookup ((VariableDecl varName varType _ _):vs)
               | varName == searchedfieldName = Just varType
               | otherwise = varDecsLookup vs


-- looks up a class in a currently visible class list
classLookup :: Type -> VisibleClassList -> Maybe Class
classLookup _         []     = Nothing
classLookup t (cl@(Class s _ _):cls) | t == s = Just cl
                                     | otherwise = classLookup t cls
                                     
-- looks up a method in a class
methodLookup :: MethodName -> Class -> Type -> MethodDecs
methodLookup searchedMethodName (Class classType _ methodDecs) thisType =
    filter filterMethodDecByName methodDecs
    where
        filterMethodDecByName (MethodDecl methodName _ _ _ Public _) =
            methodName == searchedMethodName
        filterMethodDecByName (MethodDecl methodName w x y Private z) =
            (thisType == classType)
            && filterMethodDecByName (MethodDecl methodName w x y Public z)
            
            
-- propagates the supertype of two types
propagateSuperType :: Type -> Type -> Type
propagateSuperType "void" typeB = typeB
propagateSuperType typeA "void" = typeA
propagateSuperType typeA typeB
    | typeA == typeB = typeA
    | otherwise = error $ "Types " ++ typeA ++ " and " ++ typeB
                        ++ " are not compatible"
