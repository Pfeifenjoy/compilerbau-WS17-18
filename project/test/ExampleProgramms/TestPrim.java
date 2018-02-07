class TestPrim {
	public static void main(String[] args) {
		Prime p = new Prime();

		System.out.println("Modulo test");
		System.out.println("------------");

		System.out.println("4 mod 3: " + p.modulo(4,3));
		System.out.println("9 mod 3: " + p.modulo(9,3));
		System.out.println("5 mod 2: " + p.modulo(5,2));
		System.out.println("10 mod 2: " + p.modulo(10,2));

		System.out.println("");

		System.out.println("Prim test");
		System.out.println("----------");

		for(int i = 1; i <= 10; i++) {
			System.out.println("IsPrime("+i+"): " + p.isPrime(i));
		}

		System.out.println("");

		System.out.println("Next prim");
		System.out.println("----------");

		System.out.println("NextPrime(2):" + p.nextPrime(2));
		System.out.println("NextPrime(10):" + p.nextPrime(10));
		System.out.println("NextPrime(32):" + p.nextPrime(32));

	}
}