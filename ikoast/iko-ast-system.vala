/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.System : Node {
	public SList<Constant>           constants;
	public SList<Iko.CAS.Expression> equations;
	public SList<Variable>           variables;
	public HashTable<string, Symbol> map { get; private set; }

	construct {
		map = new HashTable<string, Symbol>(str_hash, str_equal);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_system(this);
	}

	public override void accept_children(Visitor v) {
		base.accept_children(v);
		foreach(var c in constants)
			c.accept(v);
		foreach(var vb in variables)
			vb.accept(v);
	}

	public void add_constant(Constant c) {
		constants.prepend(c);
		map.insert(c.name, c);
	}

	public void add_equation(Iko.CAS.Expression eq) {
		equations.prepend(eq);
	}

	public void add_variable(Variable v) {
		variables.prepend(v);
		map.insert(v.name, v);
	}
}
