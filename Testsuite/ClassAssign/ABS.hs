Class("ClassAssign",
	 [FieldDecl("int", "a")],
	 [MethodDecl("int", "doStuff", [("int", "b")],
	 	Block([
	 		LocalVarDecl("int", "c"),
	 		StmtExpStmt(Assign(LocalOrFieldVar("c"), LocalOrFieldVar("b"))),
	 		Return(LocalOrFieldVar("b"))]
	 		))
	 ])
