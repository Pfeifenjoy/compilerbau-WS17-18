class FibonacciLoop {

	int getFib(int n) {
		int f1 = 0, f2 = 1;

		for(int i = n; i > 1; i--) {
			int tmp = f2;
			f2 += f1;
			f1 = tmp;
		}

		return (n<2) ? n : f2;
	}
}