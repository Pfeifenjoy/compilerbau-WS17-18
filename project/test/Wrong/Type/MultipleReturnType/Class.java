class MultipleReturnType {
	int i = 5;

	int doStuff() {

		if(i < 3) {
			return i;
		}
		else {
			return 'a';
		}

	}
}