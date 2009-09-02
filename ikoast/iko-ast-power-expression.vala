/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.PowerExpression : BinaryExpression {
  public PowerExpression(Expression bais, Expression exp) {
    op         = Operator.POWER;
    this.left  = bais;
    this.right = exp;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_power_expression(this);
  }
}
