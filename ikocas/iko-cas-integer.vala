/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Integer : AtomicExpression {
	public string value { get; construct; }

	public Integer(string value) {
		Object(value : value);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_integer(this);
	}
}
