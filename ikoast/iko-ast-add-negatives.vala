/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.AddNegatives : ExpressionTransformer {
	public override void visit_multiplicative_expression(MultiplicativeExpression me_in) {
		base.visit_multiplicative_expression(me_in);
		var me = q.pop_head() as MultiplicativeExpression;

		if(me.operands.data.compare_to(IntegerLiteral.MINUS_ONE) == 0) {
			me.operands.remove_link(me.operands);
			q.push_head(new NegativeExpression(me));
		} else
			q.push_head(me);
	}
}
