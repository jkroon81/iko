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
            t.add_operand_list(me.operands);
            op_list.add(t);
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
