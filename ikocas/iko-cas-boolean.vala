/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Boolean : Expression {
	public bool   bval { get; construct; }
	public string sval { get; construct; }

	public Boolean.from_bool(bool value) {
		Object(
			kind : Kind.BOOLEAN,
			bval : value,
			sval : value.to_string()
		);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_boolean(this);
	}
}
