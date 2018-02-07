class Prime {
	int modulo(int a, int b) {
		return (a - a/b * b);
	}

	boolean isPrime(int n) {
		for(int i = 2; i < n; i++) {
			if(modulo(n,i) == 0) {
				return false;
			}
		}

		return true;
	}

	int nextPrime(int n) {
		int i = n + 1;

		while(isPrime(i) == false) {
			i++;
		}

		return i;
	}
}