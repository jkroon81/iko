/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.AST.Symbol : Node {
  public string name { get; construct; }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_symbol(this);
  }
}
