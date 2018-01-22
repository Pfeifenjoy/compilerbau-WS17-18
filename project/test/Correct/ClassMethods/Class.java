class ClassMethod {
	int i = 0;

	int getInt() {
		return 1;
	}

	public static int returnInt(int x) {
		return x;
	}

	private int doStuff() {
		return this.i;
	}

}