/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.CollectSymbols : ExpressionTransformer {
  MultiplicativeExpression factorize(Expression e) {
    if(e is MultiplicativeExpression)
      return e as MultiplicativeExpression;
    else {
      var me = new MultiplicativeExpression();
      me.operands.prepend(e);
      return me;
    }
  }

  void powerize(Expression e, out Expression bais, out Expression exp) {
    if(e is PowerExpression) {
      bais = (e as PowerExpression).bais;
      exp = (e as PowerExpression).exp;
    } else {
      bais = e;
      exp = IntegerLiteral.ONE;
    }
  }

  public override void visit_division_expression(DivisionExpression de_in) {
    base.visit_division_expression(de_in);
    var de = q.pop_head() as DivisionExpression;

    var num = factorize(de.num);
    var den = factorize(de.den);
    for(unowned SList<Expression> node_1 = num.operands; node_1 != null; node_1 = node_1.next) {
      Expression num_bais, num_exp;
      powerize(node_1.data, out num_bais, out num_exp);
      for(unowned SList<Expression> node_2 = den.operands; node_2 != null; node_2 = node_2.next) {
        Expression den_bais, den_exp;
        powerize(node_2.data, out den_bais, out den_exp);
        if(num_bais.compare_to(den_bais) == 0) {
          var inv = new MultiplicativeExpression.binary(IntegerLiteral.MINUS_ONE, den_exp);
          num_exp = new AdditiveExpression.binary(num_exp, inv);
          node_1.data = new PowerExpression(num_bais, num_exp);
          den.operands.remove_link(node_2);
        }
      }
    }
    if(num.operands == null)
      num.operands.prepend(IntegerLiteral.ONE);
    if(den.operands == null)
      den.operands.prepend(IntegerLiteral.ONE);
    q.push_head(new DivisionExpression(num, den));
  }

  public override void visit_multiplicative_expression(MultiplicativeExpression me_in) {
    base.visit_multiplicative_expression(me_in);
    var me = q.pop_head() as MultiplicativeExpression;

    var me_new = new MultiplicativeExpression();
    for(unowned SList<Expression> node_1 = me.operands; node_1 != null; node_1 = node_1.next) {
      Expression bais_1, exp_1;
      powerize(node_1.data, out bais_1, out exp_1);
      for(unowned SList<Expression> node_2 = node_1.next; node_2 != null; node_2 = node_2.next) {
        Expression bais_2, exp_2;
        powerize(node_2.data, out bais_2, out exp_2);
        if(bais_1.compare_to(bais_2) == 0) {
          exp_1 = new AdditiveExpression.binary(exp_1, exp_2);
          me.operands.remove_link(node_2);
        }
      }
      me_new.operands.prepend(new PowerExpression(bais_1, exp_1));
    }
    me_new.operands.reverse();
    q.push_head(me_new);
  }
}
