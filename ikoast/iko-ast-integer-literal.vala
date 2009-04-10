/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.IntegerLiteral : Literal {
  public IntegerLiteral(string value) {
    this.value = value;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_integer_literal(this);
  }
}
