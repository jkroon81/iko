/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

int main(string[] args) {
	Environment.set_prgname("transformer");

	if(args.length == 1) {
		stdout.printf("Usage: transformer <expr>\n");
		return 0;
	}

	var context = new Iko.Context();
	var parser = new Iko.Parser();
	string src = "real A,B,C,D,E,F; %s = 0;".printf(args[1]);
	parser.parse_source_string(context, src);
	if(Iko.Report.n_errors > 0)
		return -1;
	context.accept(new Iko.TypeResolver());
	if(Iko.Report.n_errors > 0)
		return -1;
	context.accept(new Iko.MemberResolver());
	if(Iko.Report.n_errors > 0)
		return -1;

	var system = new Iko.AST.Generator().generate_system(context);
	context = null;

	assert(system.equations.length() == 1);

	var expr = system.equations.nth_data(0).left;
	stdout.printf("original           : %s\n", expr.to_string());
	expr = new Iko.AST.RemoveNegatives().transform(expr);
	stdout.printf("remove negatives   : %s\n", expr.to_string());
	expr = new Iko.AST.SimplifyPowers().transform(expr);
	stdout.printf("simplify powers    : %s\n", expr.to_string());
	expr = new Iko.AST.SimplifyRationals().transform(expr);
	stdout.printf("simplify rationals : %s\n", expr.to_string());
	expr = new Iko.AST.ExpandSymbols().transform(expr);
	stdout.printf("expand symbols     : %s\n", expr.to_string());
	expr = new Iko.AST.LevelOperators().transform(expr);
	stdout.printf("level operators    : %s\n", expr.to_string());
	expr = new Iko.AST.CollectSymbols().transform(expr);
	stdout.printf("collect symbols    : %s\n", expr.to_string());
	expr = new Iko.AST.FoldConstants().transform(expr);
	stdout.printf("fold constants     : %s\n", expr.to_string());
	expr = new Iko.AST.AddNegatives().transform(expr);
	stdout.printf("add negatives      : %s\n", expr.to_string());

	return 0;
}
