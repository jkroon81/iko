/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace Iko.CAS {
	public enum Operator {
		DIV,
		EQUAL,
		FUNCTION,
		LIST,
		MUL,
		PLUS,
		POWER;

		public string to_string() {
			switch(this) {
			case DIV:      return "/";
			case EQUAL:    return "=";
			case FUNCTION: return "<f>";
			case LIST:     return "<l>";
			case MUL:      return "*";
			case PLUS:     return "+";
			case POWER:    return "^";
			default:       assert_not_reached();
			}
		}
	}
}
