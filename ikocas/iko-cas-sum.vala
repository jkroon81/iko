/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Sum : CompoundExpression {
	public Sum.from_binary(Expression x1, Expression x2) {
		Object(op : Operator.PLUS);
		list.append(x1);
		list.append(x2);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_sum(this);
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
