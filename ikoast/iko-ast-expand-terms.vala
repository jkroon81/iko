/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.ExpandTerms : ExpressionTransformer {
  public override void visit_binary_expression(BinaryExpression be) {
    assert(be.op == Operator.DIV ||
           be.op == Operator.POWER);
    base.visit_binary_expression(be);
  }

  public override void visit_multi_expression(MultiExpression me) {
    assert(me.op == Operator.EQUAL ||
           me.op == Operator.MUL   ||
           me.op == Operator.PLUS);

    var op_list = new ArrayList<Expression>();

    foreach(var op in me.get_operands())
      op_list.add(transform(op));

    if(me.op == Operator.MUL) {
      var op_list_new = new ArrayList<Expression> ();
      var op_list_old = new ReadOnlyList<Expression>(op_list);
      foreach(var op in op_list_old) {
        if(op is MultiExpression) {
          var me_sub = op as MultiExpression;
          if(me_sub.op == Operator.PLUS) {
            op_list.remove(me_sub);
            foreach(var f1 in me_sub.get_operands()) {
              var t = new MultiExpression(Operator.MUL, null);
              t.add_operand(f1);
              t.add_operand_list(new ReadOnlyList<Expression>(op_list));
              t = transform(t) as MultiExpression;
              if(t.op == Operator.MUL)
                op_list_new.add(t);
              else if(t.op == Operator.PLUS)
                foreach(var sub_op in t.get_operands())
                  op_list_new.add(sub_op);
              else
                assert_not_reached();
            }
            break;
          }
        }
      }
      if(op_list_new.size > 0) {
        q.push_head(new MultiExpression(Operator.PLUS, new ReadOnlyList<Expression>(op_list_new)));
        return;
      }
    }
    q.push_head(new MultiExpression(me.op, new ReadOnlyList<Expression>(op_list)));
  }

  public override void visit_simple_expression(SimpleExpression se) {
    q.push_head(new BinaryExpression(Operator.POWER, se, new IntegerLiteral("1")));
  }
}
