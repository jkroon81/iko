/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace Iko.CAS {
	enum Kind {
		DERIVATIVE,
		EQUALITY,
		FRACTION,
		INTEGER,
		POWER,
		PRODUCT,
		REAL,
		SUM,
		SYMBOL
	}

	Expression copy(Expression expr) {
		if(expr is CompoundExpression)
			return new CompoundExpression.from_list(
				(expr as CompoundExpression).op,
				(expr as CompoundExpression).list
			);
		if(expr is Integer)
			return new Integer((expr as Integer).value);
		if(expr is Real)
			return new Real((expr as Real).value);
		if(expr is Symbol)
			return new Symbol((expr as Symbol).name);
		assert_not_reached();
	}

	Kind kind(Expression expr) {
		if(expr is AtomicExpression) {
			if(expr is Integer)
				return Kind.INTEGER;
			if(expr is Real)
				return Kind.REAL;
			if(expr is Symbol)
				return Kind.SYMBOL;
			assert_not_reached();
		}
		if(expr is CompoundExpression) {
			switch((expr as CompoundExpression).op) {
			case Operator.DER:
				return Kind.DERIVATIVE;
			case Operator.EQUAL:
				return Kind.EQUALITY;
			case Operator.DIV:
				return Kind.FRACTION;
			case Operator.POWER:
				return Kind.POWER;
			case Operator.MUL:
				return Kind.PRODUCT;
			case Operator.PLUS:
				return Kind.SUM;
			}
			assert_not_reached();
		}
		assert_not_reached();
	}

	int number_of_operands(Expression expr) {
		if(expr is CompoundExpression)
			return (expr as CompoundExpression).list.size;
		assert_not_reached();
	}

	public Expression operand(Expression expr, int n) {
		if(expr is CompoundExpression)
			return (expr as CompoundExpression).list[n - 1];
		assert_not_reached();
	}

	public Expression simplify(Expression expr_in) {
		var expr = copy(expr_in);
		switch(kind(expr)) {
		case Kind.FRACTION:
			return expr;
		case Kind.INTEGER:
			return expr;
		case Kind.POWER:
			return expr;
		case Kind.PRODUCT:
			var ce = expr as CompoundExpression;
			for(var node = ce.list.head; node != null; node = node.next) {
				var op = simplify(node.data);
				if(kind(op) == Kind.PRODUCT)
					node = ce.list.replace_node_with_list(node, (op as CompoundExpression).list);
				else
					node.data = op;
			}
			return ce;
		case Kind.REAL:
			return expr;
		case Kind.SUM:
			var ce = expr as CompoundExpression;
			for(var node = ce.list.head; node != null; node = node.next) {
				var op = simplify(node.data);
				if(kind(op) == Kind.SUM)
					node = ce.list.replace_node_with_list(node, (op as CompoundExpression).list);
				else
					node.data = op;
			}
			return ce;
		case Kind.SYMBOL:
			return expr;
		default:
			assert_not_reached();
		}
	}
}
