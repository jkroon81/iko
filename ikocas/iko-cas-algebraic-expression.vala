/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.AlgebraicExpression : CompoundExpression {
	public AlgebraicExpression.from_binary(Operator op, Expression expr1, Expression expr2) {
		Object(op : op);
		list.append(expr1);
		list.append(expr2);
	}

	public AlgebraicExpression.from_list(Operator op, List<Expression> list) {
		Object(op : op);
		foreach(var operand in list)
			this.list.append(operand);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_algebraic_expression(this);
	}

	public override void accept_children(Visitor v) {
		base.accept_children(v);
		foreach(var op in list)
			op.accept(v);
	}

	public override Expression eval() {
		return this;
	}
}
