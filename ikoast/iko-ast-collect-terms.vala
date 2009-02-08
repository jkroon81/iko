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

    if(me.op == Operator.MUL) {
      var op_list_new = new ArrayList<Expression>();
      var op_list_old = new ReadOnlyList<Expression>(op_list);
      foreach(var op1 in op_list_old) {
        assert(op1 is BinaryExpression);
        var f1 = op1 as BinaryExpression;
        assert(f1.op == Operator.POWER);
        op_list.remove(f1);
        foreach(var op2 in op_list) {
          var f2 = op2 as BinaryExpression;
          assert(f2.op == Operator.POWER);
          if(f1.left.equals(f2.left)) {
            var exp = new BinaryExpression(Operator.PLUS, f1.right, f2.right);
            f1 = new BinaryExpression(Operator.POWER, f1.left, exp);
            //op_list.remove(f2);
          }
        }
        op_list_new.add(f1);
      }
      var me_new = new MultiExpression(Operator.MUL);
      me_new.add_operand_list(new ReadOnlyList<Expression>(op_list_new));
      expr = me_new;
      return;
    }
    var me_new = new MultiExpression(me.op);
    me_new.add_operand_list(new ReadOnlyList<Expression>(op_list));
    expr = me_new;
  }

  public override void visit_simple_expression(SimpleExpression se) {
    expr = se;
  }
}
