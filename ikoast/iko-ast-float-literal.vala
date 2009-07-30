/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.FloatLiteral : Literal {
  public FloatLiteral(string value) {
    this.value = value;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_float_literal(this);
  }
}
