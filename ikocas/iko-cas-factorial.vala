/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Factorial : CompoundExpression {
	public Factorial.from_unary(Expression e) {
		append(e);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_factorial(this);
	}

	public override Expression eval() {
		return this;
	}
}
