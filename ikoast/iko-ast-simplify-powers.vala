/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.SimplifyPowers : ExpressionTransformer {
	public override void visit_power_expression(PowerExpression pe_in) {
		base.visit_power_expression(pe_in);
		var pe = q.pop_head() as PowerExpression;

		if(pe.radix is PowerExpression) {
			var exp = new MultiplicativeExpression.binary((pe.radix as PowerExpression).exp, pe.exp);
			q.push_head(new PowerExpression((pe.radix as PowerExpression).radix, exp));
		} else
			q.push_head(pe);
	}
}
