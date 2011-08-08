/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Symbol : AtomicExpression {
	public string name { get; construct; }

	public Symbol(string name) {
		Object(name : name);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_symbol(this);
	}

	public override Expression eval() {
		return this;
	}
}