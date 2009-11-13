/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.CompoundExpression : Expression {
	public Operator         op   { get; construct; }
	public List<Expression> list { get; private set; }

	public CompoundExpression.from_binary(Operator op, Expression expr1, Expression expr2) {
		Object(op : op);
		list.append(expr1);
		list.append(expr2);
	}

	public CompoundExpression.from_list(Operator op, List<Expression> list) {
		Object(op : op);
		foreach(var operand in list)
			this.list.append(operand);
	}

	construct {
		list = new List<Expression>();
	}
}
