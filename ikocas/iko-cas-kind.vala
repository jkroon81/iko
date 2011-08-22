/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public enum Iko.CAS.Kind {
	EQ,
	FACTORIAL,
	FRACTION,
	FUNCTION,
	INTEGER,
	LIST,
	MUL,
	PLUS,
	POWER,
	SYMBOL,
	UNDEFINED;

	public string to_string() {
		switch(this) {
		case EQ:
			return "=";
		case FACTORIAL:
			return "!";
		case FRACTION:
			return "fraction";
		case FUNCTION:
			return "function";
		case INTEGER:
			return "integer";
		case LIST:
			return "list";
		case MUL:
			return "*";
		case PLUS:
			return "+";
		case POWER:
			return "^";
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
		case EQ:
			return "Kind.EQ";
		case FACTORIAL:
			return "Kind.FACTORIAL";
		case FRACTION:
			return "Kind.FRACTION";
		case FUNCTION:
			return "Kind.FUNCTION";
		case INTEGER:
			return "Kind.INTEGER";
		case LIST:
			return "Kind.LIST";
		case MUL:
			return "Kind.MUL";
		case PLUS:
			return "Kind.PLUS";
		case POWER:
			return "Kind.POWER";
		case SYMBOL:
			return "Kind.SYMBOL";
		case UNDEFINED:
			return "Kind.UNDEFINED";
		default:
			assert_not_reached();
		}
	}
}
