/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using TestCommon;

int main() {
	int n_errors = 0;

	Environment.set_prgname("test-big-number");

	Iko.CAS.Library.init();

	n_errors += test("gpe_gcd(x^8 + 5*x^7 + 7*x^6 -3*x^5 + 4*x^4 + 17*x^3 -2*x^2 -6*x + 3, x^8 + 6*x^7 + 3*x^6 + x^5 + 10*x^4 + 8*x^3 + 2*x^2 + 9*x + 8, x)", "x+1");

	return n_errors;
}
