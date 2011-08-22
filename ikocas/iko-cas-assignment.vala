/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Assignment : Statement {
	public Symbol     symbol { get; construct; }
	public Expression expr   { get; construct; }

	public Assignment(Symbol symbol, Expression expr) {
		Object(symbol : symbol, expr : expr);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_assignment(this);
	}
}
