/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.System : Node {
	public SList<Constant>            constants;
	public SList<Iko.CAS.Expression>  equations;
	public SList<IndependentVariable> ivars;
	public SList<State>               states;
	public HashTable<string, Symbol>  map { get; private set; }

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
		foreach(var iv in ivars)
			iv.accept(v);
		foreach(var s in states)
			s.accept(v);
	}

	public void add_constant(Constant c) {
		constants.prepend(c);
		map.insert(c.name, c);
	}

	public void add_equation(Iko.CAS.Expression eq) {
		equations.prepend(eq);
	}

	public void add_independent_variable(IndependentVariable iv) {
		ivars.prepend(iv);
		map.insert(iv.name, iv);
	}

	public void add_state(State s) {
		states.prepend(s);
		map.insert(s.name, s);
	}
}
