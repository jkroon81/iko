/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.ForStatement : Statement {
	public SList<Statement> body;

	public Symbol k { get; construct; }

	public Expression start { get; construct; }

	public Expression end { get; construct; }

	public ForStatement(Symbol k, Expression start, Expression end) {
		Object(k : k, start : start, end : end);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_for_statement(this);
	}
}
