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
    case Operator.DIV:
      if(be.right is Literal) {
        var den = (be.right as Literal).value.to_double();
        if(den == 1.0)
          q.push_head(be.left);
        else if(be.left is Literal) {
          var num = (be.left as Literal).value.to_double();
          q.push_head(new FloatLiteral((num / den).to_string()));
        } else
          q.push_head(be);
      } else
        q.push_head(be);
      break;
    case Operator.POWER:
      if(be.right is Literal) {
        var exp = (be.right as Literal).value.to_double();
        if(exp == 0.0)
          q.push_head(new IntegerLiteral("1"));
        else if(exp == 1.0)
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
          var nvalue = (op as Literal).value.to_double();
          if(nvalue == 0.0) {
            q.push_head(new IntegerLiteral("0"));
            return;
          } else
            lfactor = new FloatLiteral((lfactor.value.to_double() * nvalue).to_string());
        } else
          op_list.add(op);
      }
      if(lfactor.value.to_double() != 1.0)
        op_list.add(lfactor);
      switch(op_list.size) {
      case 0:
        q.push_head(new IntegerLiteral("1"));
        break;
      case 1:
        q.push_head(op_list[0]);
        break;
      default:
        q.push_head(new MultiExpression(Operator.MUL, op_list));
        break;
      }
      break;
    case Operator.PLUS:
      Literal lterm = new IntegerLiteral("0");
      foreach(var op in me.operands) {
        if(op is Literal) {
          var nvalue = (op as Literal).value.to_double();
          lterm = new FloatLiteral((lterm.value.to_double() + nvalue).to_string());
        } else
          op_list.add(op);
      }
      if(lterm.value.to_double() != 0.0)
        op_list.add(lterm);
      switch(op_list.size) {
      case 0:
        q.push_head(new IntegerLiteral("0"));
        break;
      case 1:
        q.push_head(op_list[0]);
        break;
      default:
        q.push_head(new MultiExpression(Operator.PLUS, op_list));
        break;
      }
      break;
    default:
      q.push_head(me);
      break;
    }
  }
}
