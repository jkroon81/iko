/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.AST.ArithmeticExpression : Expression {
	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_arithmetic_expression(this);
	}
}
