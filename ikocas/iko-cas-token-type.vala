/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public enum Iko.CAS.TokenType {
	CARET,
	CLOSE_BRACE,
	CLOSE_BRACKET,
	CLOSE_PARENS,
	COMMA,
	DOT,
	EOF,
	EQ,
	FLOAT,
	IDENTIFIER,
	INTEGER,
	INVALID,
	MINUS,
	OPEN_BRACE,
	OPEN_BRACKET,
	OPEN_PARENS,
	PLUS,
	SEMICOLON,
	SLASH,
	STAR;

	public string to_string() {
		switch(this) {
		case CARET:         return "^";
		case CLOSE_BRACE:   return "}";
		case CLOSE_BRACKET: return "]";
		case CLOSE_PARENS:  return ")";
		case COMMA:         return ",";
		case DOT:           return ".";
		case EOF:           return "EOF";
		case EQ:            return "=";
		case FLOAT:         return "FLOAT";
		case IDENTIFIER:    return "IDENTIFIER";
		case INTEGER:       return "INTEGER";
		case INVALID:       return "INVALID";
		case MINUS:         return "MINUS";
		case OPEN_BRACE:    return "{";
		case OPEN_BRACKET:  return "[";
		case OPEN_PARENS:   return "(";
		case PLUS:          return "+";
		case SEMICOLON:     return ";";
		case SLASH:         return "/";
		case STAR:          return "*";
		default:            assert_not_reached();
		}
	}
}
