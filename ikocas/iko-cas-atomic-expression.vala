/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.CAS.AtomicExpression : Expression {
	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_atomic_expression(this);
	}
}
