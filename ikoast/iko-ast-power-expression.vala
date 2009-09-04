/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.PowerExpression : ArithmeticExpression {
  public Expression bais { get; construct; }
  public Expression exp  { get; construct; }

  public PowerExpression(Expression bais, Expression exp) {
    this.bais = bais;
    this.exp  = exp;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_power_expression(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    bais.accept(v);
    exp.accept(v);
  }
}
