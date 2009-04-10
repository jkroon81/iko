/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.CollectTerms : Visitor {
  Expression expr;

  public Expression collect_terms(Expression e) {
    e.accept(this);
    return expr;
  }

  public override void visit_binary_expression(BinaryExpression be) {
    assert(be.op == Operator.DIV ||
           be.op == Operator.POWER);

    be.left.accept(this);
    var left = expr;
    be.right.accept(this);
    var right = expr;
    expr = new BinaryExpression(be.op, left, right);
  }

  public override void visit_multi_expression(MultiExpression me) {
    assert(me.op == Operator.EQUAL ||
           me.op == Operator.MUL   ||
           me.op == Operator.PLUS);

    var op_list = new ArrayList<Expression>();

    foreach(var op in me.get_operands()) {
      op.accept(this);
      op_list.add(expr);
    }

    var me_new = new MultiExpression(me.op);
    me_new.add_operand_list(new ReadOnlyList<Expression>(op_list));
    expr = me_new;
  }

  public override void visit_simple_expression(SimpleExpression se) {
    expr = se;
  }
}
