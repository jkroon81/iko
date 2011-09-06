/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.ErrorStatement : Statement {
	public String msg { get; construct; }

	public ErrorStatement(String msg) {
		Object(msg : msg);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_error_statement(this);
	}
}
