/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using TestCommon;

int main() {
	int n_errors = 0;

	Environment.set_prgname("test-multivariate-polynomial");

	Iko.CAS.Library.init();

	n_errors += test("mpe_gcd(x^3*y^2 + 6*x^4*y + 9*x^5 + 4*x^2*y^2 + 24*x^3*y + 36*x^4 + 5*x*y^2 + 30*y*x^2 + 45*x^3 + 2*y^2 + 12*y*x + 18*x^2, x^5*y^2 + 8*x^4*y + 16*x^3 + 12*x^4*y^2 + 96*x^3*y + 192*x^2 + 45*x^3*y^2 + 360*y*x^2 + 720*x + 50*x^2*y^2 + 400*y*x + 800, [x,y], Z)", "x + 2");
	n_errors += test("mpe_gcd_sr(x^3*y^2 + 6*x^4*y + 9*x^5 + 4*x^2*y^2 + 24*x^3*y + 36*x^4 + 5*x*y^2 + 30*y*x^2 + 45*x^3 + 2*y^2 + 12*y*x + 18*x^2, x^5*y^2 + 8*x^4*y + 16*x^3 + 12*x^4*y^2 + 96*x^3*y + 192*x^2 + 45*x^3*y^2 + 360*y*x^2 + 720*x + 50*x^2*y^2 + 400*y*x + 800, [x,y], Z)", "x + 2");
	return n_errors;
}
