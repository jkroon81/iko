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
      var op_list = new ArrayList<Expression> ();
      foreach(var op in me.operands) {
        if(op is MultiExpression) {
          var me_sub = op as MultiExpression;
          if(me_sub.op == Operator.PLUS) {
            me.operands.remove(me_sub);
            foreach(var f1 in me_sub.operands) {
              var t = new MultiExpression(Operator.MUL, null);
              t.operands.add(f1);
              t.add_operand_list(me.operands);
              t = transform(t) as MultiExpression;
              if(t.op == Operator.MUL)
                op_list.add(t);
              else if(t.op == Operator.PLUS)
                foreach(var sub_op in t.operands)
                  op_list.add(sub_op);
              else
                assert_not_reached();
            }
            break;
          }
        }
      }
      if(op_list.size > 0) {
        q.push_head(new MultiExpression(Operator.PLUS, op_list));
        return;
      }
    }
    q.push_head(me);
  }

  public override void visit_simple_expression(SimpleExpression se_in) {
    q.push_head(new BinaryExpression(Operator.POWER, se_in, new IntegerLiteral("1")));
  }
}
