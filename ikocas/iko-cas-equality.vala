/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Equality : CompoundExpression {
	public Equality.from_binary(Expression lhs, Expression rhs) {
		append(lhs);
		append(rhs);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_equality(this);
	}
}
