/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.ExpandTerms : ExpressionTransformer {
  public override void visit_binary_expression(BinaryExpression be_in) {
    assert(be_in.op == Operator.DIV ||
           be_in.op == Operator.POWER);
    base.visit_binary_expression(be_in);
    var be = q.pop_head() as BinaryExpression;

    if(be.op == Operator.POWER) {
      if(be.right is Literal) {
        var exp = (be.right as Literal).value.to_double();
        if(exp == Math.floor(exp)) {
          if(exp > 0.0) {
            var me = new MultiExpression(Operator.MUL, null);
            for(int i = 0; i < Math.floor(exp); i++) {
              me.operands.add(be.left);
            }
            q.push_head(transform(me));
            return;
          }
        }
      }
      if(be.right is MultiExpression) {
        var be_right = be.right as MultiExpression;
        if(be_right.op == Operator.PLUS) {
          var me = new MultiExpression(Operator.MUL, null);
          foreach(var op in be_right.operands)
            me.operands.add(transform(new BinaryExpression(Operator.POWER, be.left, op)));
          q.push_head(me);
          return;
        }
      }
      if(be.left is MultiExpression) {
        var be_left = be.left as MultiExpression;
        if(be_left.op == Operator.MUL) {
          var me = new MultiExpression(Operator.MUL, null);
          foreach(var op in be_left.operands)
            me.operands.add(transform(new BinaryExpression(Operator.POWER, op, be.right)));
          q.push_head(me);
          return;
        }
      }
    }
    q.push_head(be);
  }

  public override void visit_multi_expression(MultiExpression me_in) {
    assert(me_in.op == Operator.EQUAL ||
           me_in.op == Operator.MUL   ||
           me_in.op == Operator.PLUS);
    base.visit_multi_expression(me_in);
    var me = q.pop_head() as MultiExpression;

    if(me.op == Operator.MUL) {
      var op_list = new ArrayList<Expression>();
      foreach(var op in me.operands) {
        if(op is MultiExpression && (op as MultiExpression).op == Operator.PLUS) {
          var me_sub = op as MultiExpression;
          me.operands.remove(me_sub);
          foreach(var f1 in me_sub.operands) {
            var t = new MultiExpression(Operator.MUL, null);
            t.operands.add(f1);
            t.operands.add_all(me.operands);
            op_list.add(transform(t));
          }
          break;
        }
      }
      if(op_list.size > 0) {
        q.push_head(new MultiExpression(Operator.PLUS, op_list));
        return;
      }
    }
    q.push_head(me);
  }
}
