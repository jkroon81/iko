/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.NegativeExpression : ArithmeticExpression {
	public Expression expr { get; construct; }

	public NegativeExpression(Expression expr) {
		this.expr = expr;
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_negative_expression(this);
	}

	public override void accept_children(Visitor v) {
		base.accept_children(v);
		expr.accept(v);
	}
}
