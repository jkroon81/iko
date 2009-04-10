/*
 * Iko - Copyright (C) 2008-2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public enum Iko.TokenType {
  CARET,
  CLASS,
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
  MINUS,
  MODEL,
  NAMESPACE,
  OPEN_BRACE,
  OPEN_BRACKET,
  OPEN_PARENS,
  PLUS,
  SEMICOLON,
  SLASH,
  STAR,
  STATIC;

  public string to_string() {
    switch(this) {
    case CARET:         return "^";
    case CLASS:         return "CLASS";
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
    case MINUS:         return "MINUS";
    case MODEL:         return "MODEL";
    case NAMESPACE:     return "NAMESPACE";
    case OPEN_BRACE:    return "{";
    case OPEN_BRACKET:  return "[";
    case OPEN_PARENS:   return "(";
    case PLUS:          return "+";
    case SEMICOLON:     return ";";
    case SLASH:         return "/";
    case STAR:          return "*";
    case STATIC:        return "STATIC";
    default:            assert_not_reached();
    }
  }
}
