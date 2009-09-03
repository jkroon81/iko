/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.PowerExpression : BinaryExpression {
  public PowerExpression(Expression left, Expression right) {
    this.left  = left;
    this.right = right;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_power_expression(this);
  }
}
