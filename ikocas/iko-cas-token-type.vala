/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public enum Iko.CAS.TokenType {
	AND,
	CARET,
	CLOSE_BRACE,
	CLOSE_BRACKET,
	CLOSE_PARENS,
	COMMA,
	DOT,
	ELSE,
	EOF,
	EQ,
	ERROR,
	FALSE,
	FOR,
	FOREACH,
	FUNCTION,
	GT,
	IDENTIFIER,
	IF,
	IN,
	IS,
	INTEGER,
	INVALID,
	LT,
	MINUS,
	NOT,
	OPEN_BRACE,
	OPEN_BRACKET,
	OPEN_PARENS,
	OR,
	PLUS,
	PUBLIC,
	RETURN,
	SEMICOLON,
	SLASH,
	STAR,
	STRING,
	TO,
	TRUE,
	VALA,
	WHILE;

	public string to_string() {
		switch(this) {
		case AND:           return "&";
		case CARET:         return "^";
		case CLOSE_BRACE:   return "}";
		case CLOSE_BRACKET: return "]";
		case CLOSE_PARENS:  return ")";
		case COMMA:         return ",";
		case DOT:           return ".";
		case ELSE:          return "ELSE";
		case EOF:           return "EOF";
		case EQ:            return "=";
		case ERROR:         return "ERROR";
		case FALSE:         return "FALSE";
		case FOR:           return "FOR";
		case FOREACH:       return "FOREACH";
		case FUNCTION:      return "FUNCTION";
		case GT:            return ">";
		case IDENTIFIER:    return "IDENTIFIER";
		case IF:            return "IF";
		case IN:            return "IN";
		case IS:            return "IS";
		case INTEGER:       return "INTEGER";
		case INVALID:       return "INVALID";
		case LT:            return "<";
		case MINUS:         return "MINUS";
		case NOT:           return "!";
		case OPEN_BRACE:    return "{";
		case OPEN_BRACKET:  return "[";
		case OPEN_PARENS:   return "(";
		case OR:            return "|";
		case PLUS:          return "+";
		case PUBLIC:        return "PUBLIC";
		case RETURN:        return "RETURN";
		case SEMICOLON:     return ";";
		case SLASH:         return "/";
		case STAR:          return "*";
		case STRING:        return "STRING";
		case TO:            return "TO";
		case TRUE:          return "TRUE";
		case VALA:          return "VALA";
		case WHILE:         return "WHILE";
		default:            assert_not_reached();
		}
	}
}
