/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public enum Iko.CAS.Kind {
	AND,
	ARRAY,
	BOOLEAN,
	EQ,
	FACTORIAL,
	FRACTION,
	FUNCTION,
	GE,
	GT,
	INTEGER,
	IS,
	LE,
	LIST,
	LT,
	MUL,
	NE,
	NOT,
	OR,
	PLUS,
	POWER,
	SET,
	STRING,
	SYMBOL,
	UNDEFINED;

	public string to_string() {
		switch(this) {
		case AND:
			return "&&";
		case ARRAY:
			return "array";
		case BOOLEAN:
			return "boolean";
		case EQ:
			return "=";
		case FACTORIAL:
			return "!";
		case FRACTION:
			return "fraction";
		case FUNCTION:
			return "function";
		case GE:
			return ">=";
		case GT:
			return ">";
		case INTEGER:
			return "integer";
		case IS:
			return "is";
		case LE:
			return "<=";
		case LIST:
			return "list";
		case LT:
			return "<";
		case MUL:
			return "*";
		case NE:
			return "!=";
		case NOT:
			return "!";
		case OR:
			return "||";
		case PLUS:
			return "+";
		case POWER:
			return "^";
		case SET:
			return "set";
		case STRING:
			return "string";
		case SYMBOL:
			return "symbol";
		case UNDEFINED:
			return "undefined";
		default:
			assert_not_reached();
		}
	}

	public string to_vala_string() {
		switch(this) {
		case AND:
			return "Kind.AND";
		case ARRAY:
			return "Kind.ARRAY";
		case BOOLEAN:
			return "Kind.BOOLEAN";
		case EQ:
			return "Kind.EQ";
		case FACTORIAL:
			return "Kind.FACTORIAL";
		case FRACTION:
			return "Kind.FRACTION";
		case FUNCTION:
			return "Kind.FUNCTION";
		case GE:
			return "Kind.GE";
		case GT:
			return "Kind.GT";
		case INTEGER:
			return "Kind.INTEGER";
		case IS:
			return "Kind.IS";
		case LE:
			return "Kind.LE";
		case LIST:
			return "Kind.LIST";
		case LT:
			return "Kind.LT";
		case MUL:
			return "Kind.MUL";
		case NE:
			return "Kind.NE";
		case NOT:
			return "Kind.NOT";
		case OR:
			return "Kind.OR";
		case PLUS:
			return "Kind.PLUS";
		case POWER:
			return "Kind.POWER";
		case SET:
			return "Kind.SET";
		case STRING:
			return "Kind.STRING";
		case SYMBOL:
			return "Kind.SYMBOL";
		case UNDEFINED:
			return "Kind.UNDEFINED";
		default:
			assert_not_reached();
		}
	}
}
