/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.MultiExpression : Expression {
  public ArrayList<Expression> operands { get; private set; }

  public Operator op { get; construct; }

  public MultiExpression(Operator op, ArrayList<Expression>? op_list) {
    this.op = op;
    if(op_list != null)
      add_operand_list(op_list);
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

  public void add_operand_list(ArrayList<Expression> op_list) {
    foreach(var op in op_list)
      operands.add(op);
  }
}
