/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Integer : AtomicExpression {
	public int    ival { get; construct; }
	public string sval { get; construct; }

	public Integer.from_int(int value) {
		Object(
			ival : value,
			sval : value.to_string()
		);
	}

	public Integer.from_string(string value) {
		Object(
			ival : int.parse(value),
			sval : value
		);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_integer(this);
	}

	public override Expression eval() {
		return this;
	}
}
