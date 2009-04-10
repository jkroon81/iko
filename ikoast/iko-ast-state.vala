/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.State : DataSymbol {
  ArrayList<IndependentVariable> params;
  HashTable<IndependentVariable, Expression> der_map;

  public State(string name, DataType data_type) {
    this.name      = name;
    this.data_type = data_type;
    der_map = new HashTable<IndependentVariable, Expression>(direct_hash, direct_equal);
  }

  construct {
    params = new ArrayList<IndependentVariable>();
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_state(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    foreach(var p in params)
      p.accept(v);
  }

  public void add_derivative(IndependentVariable iv, Expression expr) {
    der_map.insert(iv, expr);
  }

  public void add_parameter(IndependentVariable p) {
    params.add(p);
  }

  public Expression? get_derivative(IndependentVariable p) {
    return der_map.lookup(p);
  }

  public ReadOnlyList<IndependentVariable> get_parameters() {
    return new ReadOnlyList<Expression>(params);
  }
}
