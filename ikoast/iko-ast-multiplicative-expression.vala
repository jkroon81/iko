/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.MultiplicativeExpression : ArithmeticExpression {
  public SList<Expression> operands;

  public MultiplicativeExpression.binary(Expression left, Expression right) {
    operands.prepend(right);
    operands.prepend(left);
  }

  public MultiplicativeExpression.list(SList<Expression> op_list) {
    foreach(var op in op_list)
      operands.prepend(op);
    operands.reverse();
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_multiplicative_expression(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    foreach(var op in operands)
      op.accept(v);
  }
}
