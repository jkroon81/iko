/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using TestCommon;

int main() {
	int n_errors = 0;

	Environment.set_prgname("test-algebraic");

	Iko.CAS.Library.init();

	n_errors += test(
		"alg_division(2*x^2 + a*x, a*x + a, x, a^2-2, a)",
		"[a*x - a + 1, -a + 2]"
	);
	n_errors += test(
		"alg_gcd(x^2 + (-1 - a)*x, x^2 + (-2 - 2*a)*x + 3 + 2*a, x, a^2 - 2, a)",
		"x - 1 - a"
	);
	return n_errors;
}
