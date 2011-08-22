/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Function : Node {
	public SList<Symbol> arg;

	public SList<Statement> body;

	public string name { get; construct; }

	public bool is_public { get; construct; }

	public Function(string name, bool is_public) {
		Object(
			name : name,
			is_public : is_public
		);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_function(this);
	}
}
