/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace TestCommon {
	const string RESET = "\033[m";
	const string RED   = "\033[1;31m";
	const string GREEN = "\033[1;32m";

	public static int test(string left_in, string right_in) {
		int retval;

		var parser = new Iko.CAS.Parser();
		var left = parser.parse_source_string(left_in);
		var right = parser.parse_source_string(right_in);

		var left_gen = left.to_string();
		var right_gen = right.to_string();

		if(left_gen != right_gen) {
			stdout.printf(RED + "FAIL" + RESET);
			retval = 1;
		} else {
			stdout.printf(GREEN + "PASS" + RESET);
			retval = 0;
		}
		stdout.printf(" %s = %s [ %s = %s ]\n", left_in, right_in, left_gen, right_gen);
		return retval;
	}
}
