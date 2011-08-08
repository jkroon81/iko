/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Power : CompoundExpression {
	public Power.from_binary(Expression radix, Expression exp) {
		append(radix);
		append(exp);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_power(this);
	}

	public override Expression eval() {
		return this;
	}
}
