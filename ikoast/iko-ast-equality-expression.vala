/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.EqualityExpression : Expression {
	public Expression left  { get; construct; }
	public Expression right { get; construct; }

	public EqualityExpression(Expression left, Expression right) {
		this.left  = left;
		this.right = right;
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_equality_expression(this);
	}

	public override void accept_children(Visitor v) {
		base.accept_children(v);
		left.accept(v);
		right.accept(v);
	}
}
