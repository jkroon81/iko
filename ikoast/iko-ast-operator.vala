/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public enum Iko.AST.Operator {
  DIV,
  EQUAL,
  MINUS,
  MUL,
  PLUS,
  POWER,
  NONE;

  public int priority() {
    switch(this) {
    case DIV:   return 2;
    case EQUAL: return 1;
    case MINUS: return 1;
    case MUL:   return 2;
    case PLUS:  return 1;
    case POWER: return 3;
    default:    assert_not_reached();
    }
  }

  public string to_string() {
    switch(this) {
    case DIV:   return "/";
    case EQUAL: return "=";
    case MINUS: return "-";
    case MUL:   return "*";
    case PLUS:  return "+";
    case POWER: return "^";
    default:    assert_not_reached();
    }
  }
}
