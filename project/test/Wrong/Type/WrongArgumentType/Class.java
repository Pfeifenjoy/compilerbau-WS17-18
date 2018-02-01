class WrongArgumentType {

	int calcIt(int a, int b) {
		return a+b;
	}

	int doArithmetic() {
		return this.calcIt(1, 'a');
	}
}