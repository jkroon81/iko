/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.AdditiveExpression : ArithmeticExpression {
  public ArrayList<Expression> operands { get; private set; }

  construct {
    operands = new ArrayList<Expression>();
  }

  public AdditiveExpression.binary(Expression left, Expression right) {
    operands.add(left);
    operands.add(right);
  }

  public AdditiveExpression.list(ArrayList<Expression> op_list) {
    operands.add_all(op_list);
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_additive_expression(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    foreach(var op in operands)
      op.accept(v);
  }
}
