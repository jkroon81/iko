/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.String : AtomicExpression {
	public string value { get; construct; }

	public String(string value) {
		Object(kind : Kind.STRING, value : value);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_string(this);
	}
}
