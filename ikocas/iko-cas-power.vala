/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Power : CompoundExpression {
	public Power(Expression radix, Expression exp) {
		Object(op : Operator.POWER);
		list.append(radix);
		list.append(exp);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_power(this);
	}

	public override void accept_children(Visitor v) {
		base.accept_children(v);
		foreach(var e in list)
			e.accept(v);
	}

	public override Expression eval() {
		return this;
	}
}
