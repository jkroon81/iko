/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.AST.Literal : SimpleExpression {
  public string value { get; construct; }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_literal(this);
  }
}
