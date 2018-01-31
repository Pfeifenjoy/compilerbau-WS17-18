class BitWiseOperation {

	void doStuff() {
		int a = 1;
		int b = 2;
		a = a & b;
		a = a | b;
		a = a ^ b;
		a = a << 2;
		a = a >> 2;
		a = a >>> 2;
		a ^= a;
		a &= a;
		a |= a;
		a <<= a;
		a >>= a;
		a >>>= a;
                return;
	}
}
