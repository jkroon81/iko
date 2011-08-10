/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.CAS.Constant : AtomicExpression {
	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_constant(this);
	}
}
