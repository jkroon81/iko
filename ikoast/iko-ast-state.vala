/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.State : DataSymbol {
  public ArrayList<IndependentVariable> params { get; private set;}

  public HashTable<IndependentVariable, Expression> der { get; private set; }

  public State(string name, DataType data_type) {
    this.name      = name;
    this.data_type = data_type;
  }

  construct {
    params = new ArrayList<IndependentVariable>();
    der    = new HashTable<IndependentVariable, Expression>(direct_hash, direct_equal);
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
}
