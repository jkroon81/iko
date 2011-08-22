/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.ReturnStatement : Statement {
	public Expression expr { get; construct; }

	public ReturnStatement(Expression expr) {
		Object(expr : expr);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_return_statement(this);
	}
}
