/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.IfStatement : Statement {
	public SList<Statement> body_true;

	public SList<Statement> body_false;

	public Expression cond { get; construct; }

	public IfStatement(Expression cond) {
		Object(cond : cond);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_if_statement(this);
	}
}
