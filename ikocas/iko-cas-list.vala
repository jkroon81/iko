/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.List : CompoundExpression {
	public List() {
		Object(kind : Kind.LIST);
	}

	public List.from_binary(Expression e1, Expression e2) {
		Object(kind : Kind.LIST);
		append(e1);
		append(e2);
	}

	public List.from_unary(Expression e) {
		Object(kind : Kind.LIST);
		append(e);
	}

	public List copy() {
		var r = new List();

		foreach(var e in this)
			r.append(e);

		return r;
	}

	public List tail() {
		var r = new List();

		for(var i = 1; i < size; i++)
			r.append(this[i]);

		return r;
	}
}
