/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Equality : CompoundExpression {
	public Equality.from_binary(Expression lhs, Expression rhs) {
		Object(op : Operator.EQUAL);
		list.append(lhs);
		list.append(rhs);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_equality(this);
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
