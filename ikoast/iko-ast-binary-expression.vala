/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.BinaryExpression : Expression {
  public Operator   op    { get; construct; }
  public Expression left  { get; construct; }
  public Expression right { get; construct; }

  public BinaryExpression(Operator op, Expression left, Expression right) {
    this.op    = op;
    this.left  = left;
    this.right = right;
  }

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
