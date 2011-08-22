/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.ForEachStatement : Statement {
	public SList<Statement> body;

	public Symbol child { get; construct; }

	public Expression parent { get; construct; }

	public ForEachStatement(Symbol child, Expression parent) {
		Object(
			child : child,
			parent : parent
		);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_foreach_statement(this);
	}
}
