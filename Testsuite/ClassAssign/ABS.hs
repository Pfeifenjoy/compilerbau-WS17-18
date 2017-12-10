Class("ClassAssign",
	 [FieldDecl("int", "a")],
	 [MethodDecl("int", "doStuff", [("int", "b")],
	 	Block([
	 		LocalVarDecl("int", "c"),
	 		StmtExprStmt(Assign(LocalOrFieldVar("c"), LocalOrFieldVar("b"))),
	 		Return(LocalOrFieldVar("b"))]
	 		))
	 ])
