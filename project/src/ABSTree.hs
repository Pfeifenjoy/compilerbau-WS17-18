module ABSTree where

import Data.Int

data Type
    = TVar String
    | TC String [Type]
    | WC
    deriving(Eq, Show)

-- Statements
data Expr
    = This
    | Super
    -- variables
    | LocalOrFieldVar String
    | InstVar Expr String
    -- operators
    | Unary String Expr
    | Binary String Expr Expr
    | Ternary { ternCondition :: Expr, ternThen :: Expr, ternElse :: Expr }
    --literals
    | BooleanLiteral Bool
    | ByteLiteral Int8
    | CharLiteral Char
    | IntegerLiteral Int32
    | LongLiteral Int64
    | FloatLiteral Float
    | DoubleLiteral Double
    | StringLiteral String
    | JNull
    -- other
    | StmtExprExpr StmtExpr
    | TypedExpr Expr Type
    deriving(Eq, Show)

data StmtExpr
    = Assign Expr Expr
    | New { stmtExprType :: Type, arguments :: [Expr] }
    | MethodCall Expr String [Expr]
    | TypedStmtExpr StmtExpr Type
    deriving(Eq, Show)

data SwitchCase = Expr Stmt
    deriving(Eq, Show)

data Stmt
    = Block [Stmt]
    -- Function Statments
    | Return Expr
    -- Loop Statements
    | While { condition:: Expr, statement :: Stmt }
    | DoWhile { condition:: Expr, statement :: Stmt }
    | For { start :: Stmt, condition :: Expr, next :: Stmt, statement :: Stmt }
    -- | ForEach { iterable :: Expr, range :: Expr }
    | Break
    | Continue
    -- Conditional Statements
    | If { condition :: Expr, thenStmt :: Stmt, elseStmt :: (Maybe Stmt) }
    | Switch { variable :: Expr, cases :: [SwitchCase] }
    -- other
    | LocalVarDecl { localVarType :: Type, localVarName :: String }
    | StmtExprStmt StmtExpr
    | TypedStmt Stmt Type
    deriving(Eq, Show)

-- Classes
data FieldDecl = FieldDecl {
        fieldType :: Type,
        fieldName :: String
    }
    deriving(Eq, Show)

data ArgumentDecl = ArgumentDecl {
        argumentType :: Type,
        argumentName :: String
    }
    deriving(Eq, Show)

type ArgumentDecls = [ArgumentDecl]

data MethodDecl = MethodDecl {
        methodName :: String,
        methodReturnType :: Type,
        methodArguments :: ArgumentDecls,
        body :: Stmt
    }
    deriving(Eq, Show)

data Class = Class Type [FieldDecl] [MethodDecl]
    deriving(Eq, Show)

