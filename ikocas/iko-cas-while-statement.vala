/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.WhileStatement : Statement {
	public SList<Statement> body;

	public Expression cond { get; construct; }

	public WhileStatement(Expression cond) {
		Object(cond : cond);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_while_statement(this);
	}
}
