/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.AST.BinaryExpression : Expression {
  public Operator   op    { get; construct; }
  public Expression left  { get; construct; }
  public Expression right { get; construct; }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_binary_expression(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    left.accept(v);
    right.accept(v);
  }
}
