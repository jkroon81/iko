/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.FoldConstants : ExpressionTransformer {
  public override void visit_binary_expression(BinaryExpression be_in) {
    assert(be_in.op == Operator.DIV ||
           be_in.op == Operator.POWER);
    base.visit_binary_expression(be_in);

    var be = q.pop_head() as BinaryExpression;
    switch(be.op) {
    case Operator.POWER:
      if(be.right is Literal) {
        if((be.right as Literal).value.to_double() == 0.0)
          q.push_head(new IntegerLiteral("1"));
        else if((be.right as Literal).value.to_double() == 1.0)
          q.push_head(be.left);
        else
          q.push_head(be);
      } else
        q.push_head(be);
      break;
    default:
      q.push_head(be);
      break;
    }
  }

  public override void visit_multi_expression(MultiExpression me_in) {
    assert(me_in.op == Operator.EQUAL ||
           me_in.op == Operator.MUL   ||
           me_in.op == Operator.PLUS);
    base.visit_multi_expression(me_in);

    var me = q.pop_head() as MultiExpression;
    var op_list = new ArrayList<Expression>();
    switch(me.op) {
    case Operator.MUL:
      Literal lfactor = new IntegerLiteral("1");
      foreach(var op in me.operands) {
        if(op is Literal) {
          var l = op as Literal;
          if(l.value.to_double() == 0.0) {
            q.push_head(new IntegerLiteral("0"));
            return;
          } else if(l.value.to_double() == 1.0)
            continue;
          else {
            if(lfactor is IntegerLiteral) {
              if(l is IntegerLiteral)
                lfactor = new IntegerLiteral((lfactor.value.to_int() * l.value.to_int()).to_string());
              else if(l is FloatLiteral)
                lfactor = new FloatLiteral((lfactor.value.to_int() * l.value.to_double()).to_string());
            } else if(lfactor is FloatLiteral) {
              lfactor = new FloatLiteral((lfactor.value.to_double() * l.value.to_double()).to_string());
            } else
              assert_not_reached();
          }
        } else
          op_list.add(op);
      }
      if(lfactor.value.to_double() != 1.0)
        op_list.add(lfactor);
      if(op_list.size == 0)
        q.push_head(new IntegerLiteral("1"));
      else if(op_list.size == 1)
        q.push_head(op_list[0]);
      else
        q.push_head(new MultiExpression(Operator.MUL, op_list));
      break;
    case Operator.PLUS:
      foreach(var op in me.operands) {
        if(op is Literal && (op as Literal).value.to_double() == 0.0)
          continue;
        else
          op_list.add(op);
      }
      if(op_list.size == 0)
        q.push_head(new IntegerLiteral("0"));
      else if(op_list.size == 1)
        q.push_head(op_list[0]);
      else
        q.push_head(new MultiExpression(Operator.PLUS, op_list));
      break;
    default:
      q.push_head(me);
      break;
    }
  }
}
