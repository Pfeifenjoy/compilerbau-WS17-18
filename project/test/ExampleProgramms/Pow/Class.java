class Pow {
	int pow(int a, int b) {
		int ret = 1;

		for(int i = 0; i < b; i++) {
			ret *= a;
		}

		return ret;
	}
}