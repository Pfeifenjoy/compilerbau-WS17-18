module TypeChecker where

import ABSTree

-- local variable table
type LocVarTable = [(String, Type)] 

-- MAIN TYPECHECK FUNCTION
checkTypes :: Program -> Program
checkTypes classList = map checkClass classList
   where 
      checkClass (Class classType fieldDecs methodDecs) =
          let (locVarTable, typeCheckedFieldDecs) = typeCheckFieldDecs fieldDecs classType classList
              typeCheckedMethodDecs = typeCheckMethodDecs methodDecs locVarTable classList
          in Class classType
                   typeCheckedFieldDecs
                   typeCheckedMethodDecs
                   
-- TYPECHECK FIELD DECLARATIONS (and create a LocVarTable in the process)
typeCheckFieldDecs :: [FieldDecl] -> Type -> [Class] -> (LocVarTable, [FieldDecl])
typeCheckFieldDecs fieldDecs classType cls = iterateOverFieldDecs ([],[]) fieldDecs
    where
        iterateOverFieldDecs res [] = res
        iterateOverFieldDecs (ctbl, cfs) ((FieldDecl varDecs vis stat):fs) =
            let (ntbl, tVarDecs) = iterateOverVarDecs (ctbl, []) varDecs
            in iterateOverFieldDecs (ntbl, cfs ++ [(FieldDecl tVarDecs vis stat)]) fs
            
        iterateOverVarDecs res [] = res
        iterateOverVarDecs (ctbl, cVarDecs) (var@(VariableDecl vName vType vFinal vExpr):vs) =
            let typedVar = case vExpr of
                    Nothing -> var
                    (Just expr) -> VariableDecl vName vType vFinal (Just (typeCheckExpr expr ctbl cls))
            in iterateOverVarDecs ((vName, vType):ctbl, cVarDecs ++ [typedVar]) vs               
                   
    
-- TYPECHECK METHOD DECLARATIONS
-- TODO: standard of method declarations 
typeCheckMethodDecs :: [MethodDecl] -> LocVarTable -> [Class] -> [MethodDecl]
typeCheckMethodDecs = undefined 

-- TYPECHECK EXPRESSIONS:
-------------------------
typeCheckExpr :: Expr -> LocVarTable -> [Class] -> Expr
-- handling literals 
typeCheckExpr expr@(BooleanLiteral _) _ _ = TypedExpr expr "boolean"
typeCheckExpr expr@(CharLiteral _)    _ _ = TypedExpr expr "char"
typeCheckExpr expr@(IntegerLiteral _) _ _ = TypedExpr expr "integer"
-- handling unary operators
typeCheckExpr (Unary operator operandExpr) tbl cls = 
    let typedOperandExpr = typeCheckExpr operandExpr tbl cls
        operandType = getTypeFromTypedExpr typedOperandExpr
        typedUnaryExpr = Unary operator typedOperandExpr
    in case operandType of
        "integer" -> if operator `elem` ["+", "-", "++", "--"]
                     then TypedExpr typedUnaryExpr "integer"
                     else error "Operand type not compatible"
        "boolean" -> if operator == "!"
                     then TypedExpr typedUnaryExpr "boolean"
                     else error "Operand type not compatible"
        other     -> error "Unknown unary operator"
-- handling binary operators
typeCheckExpr (Binary operator operandExprA operandExprB) tbl cls =
    let typedOperandExprA = typeCheckExpr operandExprA tbl cls
        typedOperandExprB = typeCheckExpr operandExprB tbl cls
        operandTypeA = getTypeFromTypedExpr typedOperandExprA
        operandTypeB = getTypeFromTypedExpr typedOperandExprB
        typedBinaryExpr = Binary operator typedOperandExprA typedOperandExprB
    in case (operandTypeA, operandTypeB) of
        ("integer", "integer") -> if operator `elem` ["+", "-", "*", "/", "%"]
                                  then TypedExpr typedBinaryExpr "integer"
                                  -- TODO: null handling: (bla == null)?
                                  else if operator `elem` [">", "<", ">=", "<=", "=="]
                                       then TypedExpr typedBinaryExpr "boolean"
                                       else error "Operand types not compatible"
        ("boolean", "boolean") -> if operator `elem` ["&&", "||"]
                                  then TypedExpr typedBinaryExpr "boolean"
                                  else error "Operand types not compatible"
        _                      -> error "Unknown binary operator"
-- handling ternary operator
typeCheckExpr (Ternary operandExprA operandExprB operandExprC) tbl cls =
    let typedOperandExprA = typeCheckExpr operandExprA tbl cls
        typedOperandExprB = typeCheckExpr operandExprB tbl cls
        typedOperandExprC = typeCheckExpr operandExprC tbl cls
        operandTypeA = getTypeFromTypedExpr typedOperandExprA
        operandTypeB = getTypeFromTypedExpr typedOperandExprB
        operandTypeC = getTypeFromTypedExpr typedOperandExprC
    in if operandTypeA == "boolean"
       -- TODO: type/class hierarchy ? 
       then if operandTypeB == operandTypeC
            then TypedExpr (Ternary typedOperandExprA 
                                    typedOperandExprB
                                    typedOperandExprC)
                           operandTypeB
            else error "..."
       else error "..."
-- handling this
typeCheckExpr This tbl cls =
    -- TODO: correct handling of this ?
    let maybeTypeOfThis = lookup "this" tbl
    in case maybeTypeOfThis of
        Just typeOfThis -> TypedExpr This typeOfThis
        Nothing         -> error "'this' can not be referrenced"
-- handling local/field variables
typeCheckExpr expr@(LocalOrFieldVar varName) tbl cls = 
    let maybeVarType = lookup varName tbl
    in case maybeVarType of
        Just varType -> TypedExpr expr varType
        Nothing      -> error "..."   
-- handling instance variables
typeCheckExpr (InstVar instanceExpr varName) tbl cls =
    let typedInstanceExpr = typeCheckExpr instanceExpr tbl cls
        instanceType      = getTypeFromTypedExpr typedInstanceExpr
    in case classLookup instanceType cls of
        Nothing            -> error "..."
        Just instanceClass -> 
            case classFieldTypeLookup varName instanceClass of
                Nothing          -> error "..."
                Just instVarType ->
                    TypedExpr (InstVar typedInstanceExpr varName) instVarType
-- handling statement expressions
typeCheckExpr (StmtExprExpr stmtExpr) tbl cls = 
    let typedStmtExpr = typeCheckStmtExpr stmtExpr tbl cls
        stmtExprType = getTypeFromTypedStmtExpr typedStmtExpr
    in TypedExpr (StmtExprExpr typedStmtExpr) stmtExprType                   
-- handling null
typeCheckExpr JNull _ _ = TypedExpr JNull "void"
-- handling already type expressions
typeCheckExpr (TypedExpr _ _) _ _ =
    error "Trying to typecheck an already typechecked expression"

-- TYPECHECKER EXPRESSION STATEMENTS
typeCheckStmtExpr :: StmtExpr -> LocVarTable -> [Class] -> StmtExpr
typeCheckStmtExpr (Assign leftValExpr rightValExpr) tbl cls = 
    let typedLeftValExpr = typeCheckExpr leftValExpr tbl cls 
        typedRightValExpr = typeCheckExpr rightValExpr tbl cls
        leftValType  = getTypeFromTypedExpr typedLeftValExpr
        rightValType = getTypeFromTypedExpr typedRightValExpr
    in if   (leftValType == rightValType)
       then TypedStmtExpr (Assign typedLeftValExpr
                                  typedRightValExpr)
                          rightValType
       else error "Assign error"
typeCheckStmtExpr (New newType arguments) tbl cls =
    -- TODO: is 'argument influencing' important for typechecker ?
    TypedStmtExpr (New newType (map (\expr -> typeCheckExpr expr tbl cls)
                                    arguments))
                  newType
typeCheckStmtExpr (LazyAssign exprA exprB) tbl cls =
    case typeCheckStmtExpr (Assign exprA exprB) tbl cls of
        TypedStmtExpr (Assign typedExprA typedExprB) t ->
            TypedStmtExpr (LazyAssign typedExprA typedExprB) t
        _   -> error " "
       
-- TYPECHECK STATEMENTS
typeCheckStmt :: Stmt -> LocVarTable -> [Class] -> Stmt
typeCheckStmt (Block stmts) tbl cls = Block (iterateOverBlock stmts tbl cls)
    where
    iterateOverBlock [] _ _ = []
typeCheckStmt (Return returnExpr) tbl cls =
    let typedReturnExpr = typeCheckExpr returnExpr tbl cls
        returnExprType = getTypeFromTypedExpr typedReturnExpr
    in TypedStmt (Return typedReturnExpr) returnExprType
typeCheckStmt (While whileExpr whileStmt) tbl cls =
    let typedWhileExpr = typeCheckExpr whileExpr tbl cls
        whileExprType = getTypeFromTypedExpr typedWhileExpr
    in case whileExprType of
        "boolean" -> let typedWhileStmt = typeCheckStmt whileStmt tbl cls
                         whileStmtType = getTypeFromTypedStmt typedWhileStmt
                     in TypedStmt (While typedWhileExpr whileStmt) whileStmtType                     
        _         -> error "While expression must be of boolean type"
typeCheckStmt (DoWhile doWhileExpr doWhileStmt) tbl cls =
    let (TypedStmt (While a b) t) = typeCheckStmt (While doWhileExpr doWhileStmt) tbl cls 
    in TypedStmt (DoWhile a b) t
typeCheckStmt (For _ _ _ _) tbl cls = undefined
typeCheckStmt Break _ _ = TypedStmt Break "void"
typeCheckStmt Continue _ _ = TypedStmt Continue "void"
typeCheckStmt (If ifExpr thenStmt elseStmt) tbl cls = undefined

-- TYPECHECK STATEMENTS AND (POSSIBLY) TRANSFORM LOCAL VARIABLE TABLE
typeCheckStmtLocVar :: Stmt -> LocVarTable -> [Class] -> (Stmt, LocVarTable)
-- statments that don't transfrom the current LocVarTable
-- Block, While, DoWhile, For, If, Switch 
typeCheckStmtLocVar stmt tbl cls = (typeCheckStmt stmt tbl cls, tbl) 

-- HELPER FUNCTIONS:
-- lookup a certain type in a list of classes
classLookup :: Type -> [Class] -> Maybe Class
classLookup _         []     = Nothing
classLookup t (cl@(Class s _ _):cls) | t == s = Just cl
                                     | otherwise = classLookup t cls

-- extracts a LocVarTable from a list of field declarations
extractLocVarTable :: [FieldDecl] -> LocVarTable
extractLocVarTable = undefined 
-- lookup the type of a fieldname in a class
classFieldTypeLookup :: String -> Class -> Maybe Type
classFieldTypeLookup varName (Class _ fieldDecList _) =
    let publicFieldDecList = filter (\(FieldDecl _ vis _) -> vis == Public) 
                                    fieldDecList
    in fieldDecListLookup $ publicFieldDecList
    where
        -- TODO: Multiple entries possible (???)
        fieldDecListLookup [] = Nothing
        fieldDecListLookup ((FieldDecl varDecList _ _):xs) =
            case filter (\(VariableDecl fieldName _ _ _) -> fieldName == varName)
                        varDecList
            of
                [(VariableDecl _ fieldType _ _)] -> Just fieldType 
                _                                -> Nothing 

-- extract type from typed expression
getTypeFromTypedExpr :: Expr -> Type
getTypeFromTypedExpr (TypedExpr _ exprType) = exprType

-- extract type from type statement expression
getTypeFromTypedStmtExpr :: StmtExpr -> Type
getTypeFromTypedStmtExpr (TypedStmtExpr _ stmtExprType) = stmtExprType

-- extract type from typed statement
getTypeFromTypedStmt :: Stmt -> Type
getTypeFromTypedStmt (TypedStmt _ stmtType) = stmtType