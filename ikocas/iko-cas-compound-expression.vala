/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.CAS.CompoundExpression : Expression {
	public Operator               op   { get; construct; }
	public LinkedList<Expression> list { get; private set; }

	construct {
		list = new LinkedList<Expression>();
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_compound_expression(this);
	}

	public override void accept_children(Visitor v) {
		base.accept_children(v);
		foreach(var op in list)
			op.accept(v);
	}
}
