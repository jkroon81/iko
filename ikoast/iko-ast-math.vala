/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace Iko.AST.Math {
	public Expression simplify(Expression expr_in) {
		var expr = expr_in;
		expr = new RemoveNegatives().transform(expr);
		expr = new SimplifyPowers().transform(expr);
		expr = new SimplifyRationals().transform(expr);
		expr = new ExpandSymbols().transform(expr);
		expr = new LevelOperators().transform(expr);
		expr = new CollectSymbols().transform(expr);
		expr = new FoldConstants().transform(expr);
		expr = new AddNegatives().transform(expr);
		return expr;
	}
}
