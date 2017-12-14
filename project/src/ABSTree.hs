module ABSTree where

import Data.Int

type Type = String

-- Statements
data Expr
    = This
    -- | Super
    -- variables
    | LocalOrFieldVar String
    | InstVar Expr String
    -- operators
    | Unary String Expr
    | Binary String Expr Expr -- (&&, ||, ..., instanceOf)
    | InstanceOf Expr Type
    -- TODO extra instanceOf
    | Ternary Expr Expr Expr -- expr1 ? expr2 : expr3
    --literals
    | BooleanLiteral Bool
    -- | ByteLiteral Int8
    | CharLiteral Char
    | IntegerLiteral Int32
    -- | LongLiteral Int64
    -- | FloatLiteral Float
    -- | DoubleLiteral Double
    -- | StringLiteral String
    | JNull
    -- other
    | StmtExprExpr StmtExpr
    | TypedExpr Expr Type
    deriving(Eq, Show)

data VariableDecl
    = Variable String Type Bool -- name, type, final
    deriving(Eq, Show)

data StmtExpr
    = Assign Expr Expr
    | New Type [Expr] -- type, arguments
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
    | While Expr Stmt -- condition, statement
    | DoWhile Expr Stmt -- condition, statement
    | For Stmt Expr Stmt Stmt -- for(stmt1, expr, stmt2) stmt3
    -- | ForEach { iterable :: Expr, range :: Expr }
    | Break
    | Continue
    -- Conditional Statements
    | If Expr Stmt (Maybe Stmt) -- condition, stmt, elseStmt
    | Switch Expr [SwitchCase] (Maybe Stmt) -- variable, cases, finally
    -- other
    | LocalVarDecl VariableDecl
    | StmtExprStmt StmtExpr
    | TypedStmt Stmt Type
    deriving(Eq, Show)


data Visibility
    = Public
    | Private
    -- | Protected
    deriving(Eq, Show)

-- Classes
data FieldDecl = FieldDecl VariableDecl Visibility Bool -- variable, private/protected, static
    deriving(Eq, Show)

type ArgumentDecl = VariableDecl

type ArgumentDecls = [ArgumentDecl]

data MethodDecl = MethodDecl String Type ArgumentDecls Stmt Visibility Bool -- name, type, arguments, stmt (only block statement!!!), private/protected, static
    deriving(Eq, Show)

data Class = Class Type [FieldDecl] [MethodDecl]
    deriving(Eq, Show)

