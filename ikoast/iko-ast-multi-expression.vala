/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.MultiExpression : Expression {
  ArrayList<Expression> operands;

  public Operator op { get; construct; }

  public MultiExpression(Operator op) {
    this.op = op;
  }

  construct {
    operands = new ArrayList<Expression>();
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_multi_expression(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    foreach(var o in operands)
      o.accept(v);
  }

  public void add_operand(Expression op) {
    operands.add(op);
  }

  public void add_operand_list(ReadOnlyList<Expression> op_list) {
    foreach(var op in op_list)
      operands.add(op);
  }

  public ReadOnlyList<Expression> get_operands() {
    return new ReadOnlyList<Expression>(operands);
  }
}
