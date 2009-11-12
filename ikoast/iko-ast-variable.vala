/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.Variable : DataSymbol {
	public SList<Variable> params;

	public HashTable<Variable, Iko.CAS.Expression> der { get; private set; }

	public Variable(string name, DataType data_type) {
		Object(name : name, data_type : data_type);
	}

	construct {
		der = new HashTable<Variable, Iko.CAS.Expression>(direct_hash, direct_equal);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_variable(this);
	}

	public override void accept_children(Visitor v) {
		base.accept_children(v);
		foreach(var p in params)
			p.accept(v);
	}
}
