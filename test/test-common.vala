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

	public static int test(string left, string right) {
		int retval;

		var context = new Iko.Context();
		var parser = new Iko.Parser();
		string src = "real A,B,C,D,E,F; %s = %s;".printf(left, right);
		parser.parse_source_string(context, src);
		context.accept(new Iko.SymbolResolver());

		var system = new Iko.AST.Generator().generate_system(context);
		context = null;

		assert(system.equations.length() == 1);

		var left_gen = Iko.CAS.to_string(
			Iko.CAS.simplify(
				Iko.CAS.operand(system.equations.nth_data(0), 1)
			)
		);
		var right_gen = Iko.CAS.to_string(
			Iko.CAS.simplify(
				Iko.CAS.operand(system.equations.nth_data(0), 2)
			)
		);

		if(left_gen != right_gen) {
			stdout.printf(RED + "FAIL" + RESET);
			retval = 1;
		} else {
			stdout.printf(GREEN + "PASS" + RESET);
			retval = 0;
		}
		stdout.printf(" %s = %s [ %s = %s ]\n", left, right, left_gen, right_gen);
		return retval;
	}
}
