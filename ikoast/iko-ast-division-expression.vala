/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.DivisionExpression : ArithmeticExpression {
  public Expression num { get; construct; }
  public Expression den { get; construct; }

  public DivisionExpression(Expression num, Expression den) {
    this.num = num;
    this.den = den;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_division_expression(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    num.accept(v);
    den.accept(v);
  }
}
