/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Undefined : Expression {
	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_undefined(this);
	}

	public override Expression eval() {
		return this;
	}
}