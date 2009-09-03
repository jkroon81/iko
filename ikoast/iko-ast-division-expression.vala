/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.DivisionExpression : BinaryExpression {
  public DivisionExpression(Expression left, Expression right) {
    this.left  = left;
    this.right = right;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_division_expression(this);
  }
}
