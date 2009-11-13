/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace Iko.CAS {
	bool protect(Expression expr, int i) {
		var parent = kind(expr);
		var child = kind(operand(expr, i));
		switch(parent) {
		case Kind.EQUALITY:
			return false;
		case Kind.FRACTION:
			switch(child) {
			case Kind.INTEGER:
			case Kind.POWER:
			case Kind.SYMBOL:
				return false;
			case Kind.PRODUCT:
				if(i == 1)
					return false;
				else
					return true;
			default:
				return true;
			}
		case Kind.POWER:
			switch(child) {
			case Kind.INTEGER:
			case Kind.SYMBOL:
				return false;
			default:
				return true;
			}
		case Kind.PRODUCT:
			switch(child) {
			case Kind.FRACTION:
			case Kind.INTEGER:
			case Kind.POWER:
			case Kind.REAL:
			case Kind.SYMBOL:
				return false;
			default:
				return true;
			}
		case Kind.SUM:
			switch(child) {
			case Kind.INTEGER:
			case Kind.POWER:
			case Kind.PRODUCT:
			case Kind.SYMBOL:
				return false;
			default:
				return true;
			}
		default:
			return true;
		}
	}

	public string to_string(Expression expr) {
		switch(kind(expr)) {
		case Kind.DERIVATIVE:
			string str = "der(";
			for(var i = 1; i <= number_of_operands(expr); i++) {
				str += to_string(operand(expr, i));
				if(i != number_of_operands(expr))
					str += ",";
			}
			str += ")";
			return str;
		case Kind.EQUALITY:
		case Kind.FRACTION:
		case Kind.POWER:
		case Kind.PRODUCT:
		case Kind.SUM:
			string str = "";
			for(var i = 1; i <= number_of_operands(expr); i++) {
				if(protect(expr, i))
					str += "(";
				str += to_string(operand(expr, i));
				if(protect(expr, i))
					str += ")";
				if(i != number_of_operands(expr))
					str += (expr as CompoundExpression).op.to_string();
			}
			return str;
		case Kind.INTEGER:
			return (expr as Integer).value;
		case Kind.REAL:
			return (expr as Real).value;
		case Kind.SYMBOL:
			return (expr as Symbol).name;
		default:
			assert_not_reached();
		}
	}
}
