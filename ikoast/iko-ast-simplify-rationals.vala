/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.SimplifyRationals : ExpressionTransformer {
  public override void visit_division_expression(DivisionExpression de_in) {
    base.visit_division_expression(de_in);
    var de = q.pop_head() as DivisionExpression;

    if(de.num is DivisionExpression) {
      var num = de.num as DivisionExpression;
      var den = new MultiplicativeExpression.binary(num.den, de.den);
      q.push_head(new DivisionExpression(num.num, den));
    } else if(de.den is DivisionExpression) {
      var den = de.den as DivisionExpression;
      var num = new MultiplicativeExpression.binary(de.num, den.den);
      q.push_head(new DivisionExpression(num, den.num));
    } else
      q.push_head(de);
  }

  public override void visit_multiplicative_expression(MultiplicativeExpression me_in) {
    base.visit_multiplicative_expression(me_in);
    var me = q.pop_head() as MultiplicativeExpression;

    for(var i = 0; i < me.operands.size; i++) {
      var op = me.operands[i];
      if(op is DivisionExpression) {
        var de = op as DivisionExpression;
        var num = new MultiplicativeExpression.list(me.operands);
        num.operands.remove(op);
        num.operands.add(de.num);
        q.push_head(new DivisionExpression(num, de.den));
        return;
      }
    }
    q.push_head(me);
  }
}
