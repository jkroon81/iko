/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.ExpandTerms : Visitor {
  Expression expr;

  public Expression expand_terms(Expression e) {
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
      var op_list_new = new ArrayList<Expression> ();
      var op_list_old = new ReadOnlyList<Expression>(op_list);
      foreach(var op in op_list_old) {
        if(op is MultiExpression) {
          var me_sub = op as MultiExpression;
          if(me_sub.op == Operator.PLUS) {
            op_list.remove(me_sub);
            foreach(var f1 in me_sub.get_operands()) {
              var t = new MultiExpression(Operator.MUL);
              t.add_operand(f1);
              foreach(var f2 in op_list)
                t.add_operand(f2);
              t.accept(this);
              if((expr as MultiExpression).op == Operator.MUL)
                op_list_new.add(expr);
              else if((expr as MultiExpression).op == Operator.PLUS)
                foreach(var sub_op in (expr as MultiExpression).get_operands())
                  op_list_new.add(sub_op);
              else
                assert_not_reached();
            }
            break;
          }
        }
      }
      if(op_list_new.size > 0) {
        var me_new = new MultiExpression(Operator.PLUS);
        me_new.add_operand_list(new ReadOnlyList<Expression>(op_list_new));
        expr = me_new;
        return;
      }
    }
    var me_new = new MultiExpression(me.op);
    me_new.add_operand_list(new ReadOnlyList<Expression>(op_list));
    expr = me_new;
  }

  public override void visit_simple_expression(SimpleExpression se) {
    expr = new BinaryExpression(Operator.POWER, se, new IntegerLiteral("1"));
  }
}
