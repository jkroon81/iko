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

	public static int test(string lhs_in, string rhs_in) {
		Iko.CAS.Expression lhs, rhs;
		string lhs_gen, rhs_gen;
		int retval;

		var parser = new Iko.CAS.Parser();

		try {
			lhs = parser.parse_source_string(lhs_in);
			rhs = parser.parse_source_string(rhs_in);
			lhs_gen = Iko.CAS.Library.simplify(lhs).to_string();
			rhs_gen = Iko.CAS.Library.simplify(rhs).to_string();
		} catch(Iko.CAS.Error e) {
			assert_not_reached();
		}

		if(lhs_gen != rhs_gen) {
			stdout.printf(RED + "FAIL" + RESET);
			retval = 1;
		} else {
			stdout.printf(GREEN + "PASS" + RESET);
			retval = 0;
		}
		stdout.printf(" %s = %s [ %s = %s ]\n", lhs_in, rhs_in, lhs_gen, rhs_gen);
		return retval;
	}
}
