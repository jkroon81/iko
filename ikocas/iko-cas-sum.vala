/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Sum : CompoundExpression {
	public Sum.from_binary(Expression x1, Expression x2) {
		append(x1);
		append(x2);
	}

	public Sum.from_list(List l) {
		foreach(var t in l)
			append(t);
	}

	public Sum.from_unary(Expression e) {
		append(e);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_sum(this);
	}
}
