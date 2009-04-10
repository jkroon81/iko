/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.System : Node {
  ArrayList<Constant>            constants;
  ArrayList<BinaryExpression>    equations;
  ArrayList<IndependentVariable> ivars;
  ArrayList<Method>              methods;
  ArrayList<State>               states;

  HashTable<string, Symbol> bank;

  construct {
    constants = new ArrayList<Constant>();
    equations = new ArrayList<BinaryExpression>();
    ivars = new ArrayList<IndependentVariable>();
    methods = new ArrayList<Method>();
    states = new ArrayList<State>();
    bank = new HashTable<string, Symbol>(str_hash, str_equal);
    add_method(new DerivativeMethod());
    add_method(new SquareRootMethod());
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_system(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    foreach(var c in constants)
      c.accept(v);
    foreach(var iv in ivars)
      iv.accept(v);
    foreach(var s in states)
      s.accept(v);
    foreach(var m in methods)
      m.accept(v);
    foreach(var eq in equations)
      eq.accept(v);
  }

  public void add_constant(Constant c) {
    constants.add(c);
    bank.insert(c.name, c);
  }

  public void add_equation(BinaryExpression eq) {
    assert(eq.op == Operator.EQUAL);
    equations.add(eq);
  }

  public void add_independent_variable(IndependentVariable iv) {
    ivars.add(iv);
    bank.insert(iv.name, iv);
  }

  public void add_method(Method m) {
    methods.add(m);
    bank.insert(m.name, m);
  }

  public void add_state(State s) {
    states.add(s);
    bank.insert(s.name, s);
  }

  public ReadOnlyList<Constant> get_constants() {
    return new ReadOnlyList<Constant>(constants);
  }

  public ReadOnlyList<BinaryExpression> get_equations() {
    return new ReadOnlyList<BinaryExpression>(equations);
  }

  public ReadOnlyList<IndependentVariable> get_independent_variables() {
    return new ReadOnlyList<IndependentVariable>(ivars);
  }

  public ReadOnlyList<Method> get_methods() {
    return new ReadOnlyList<Method>(methods);
  }

  public ReadOnlyList<State> get_states() {
    return new ReadOnlyList<State>(states);
  }

  public Symbol lookup(string name) {
    return bank.lookup(name);
  }
}
