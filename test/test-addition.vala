/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using TestCommon;

int main() {
	int n_errors = 0;

	Environment.set_prgname("test-addition");

	n_errors += test("A + B", "B + A");
	n_errors += test("( A + B ) + C", "A + ( B + C )");
	n_errors += test("A + 0", "A");
	return n_errors;
}
