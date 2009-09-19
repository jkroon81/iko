/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.CollectSymbols : ExpressionTransformer {
  bool equals(Expression e1, Expression e2) {
    if(e1 is SymbolAccess && e2 is SymbolAccess)
      return (e1 as SymbolAccess).symbol == (e2 as SymbolAccess).symbol;
    else
      return false;
  }

  MultiplicativeExpression factorize(Expression e) {
    if(e is MultiplicativeExpression)
      return e as MultiplicativeExpression;
    else {
      var me = new MultiplicativeExpression();
      me.operands.add(e);
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
    for(int i = 0; i < num.operands.size; i++) {
      Expression num_bais, num_exp;
      powerize(num.operands[i], out num_bais, out num_exp);
      for(int j = 0; j < den.operands.size; j++) {
        Expression den_bais, den_exp;
        powerize(den.operands[j], out den_bais, out den_exp);
        if(equals(num_bais, den_bais)) {
          var inv = new MultiplicativeExpression.binary(IntegerLiteral.MINUS_ONE, den_exp);
          num_exp = new AdditiveExpression.binary(num_exp, inv);
          num.operands[i] = new PowerExpression(num_bais, num_exp);
          den.operands.remove_at(j);
          j--;
        }
      }
    }
    if(num.operands.size == 0)
      num.operands.add(IntegerLiteral.ONE);
    if(den.operands.size == 0)
      den.operands.add(IntegerLiteral.ONE);
    q.push_head(new DivisionExpression(num, den));
  }

  public override void visit_multiplicative_expression(MultiplicativeExpression me_in) {
    base.visit_multiplicative_expression(me_in);
    var me = q.pop_head() as MultiplicativeExpression;

    var me_new = new MultiplicativeExpression();
    for(int i = 0; i < me.operands.size; i++) {
      Expression bais_1, exp_1;
      powerize(me.operands[i], out bais_1, out exp_1);
      for(int j = i + 1; j < me.operands.size; j++) {
        Expression bais_2, exp_2;
        powerize(me.operands[j], out bais_2, out exp_2);
        if(equals(bais_1, bais_2)) {
          exp_1 = new AdditiveExpression.binary(exp_1, exp_2);
          me.operands.remove_at(j);
          j--;
        }
      }
      me_new.operands.add(new PowerExpression(bais_1, exp_1));
    }
    q.push_head(me_new);
  }
}
