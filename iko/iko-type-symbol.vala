/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.TypeSymbol : Symbol {
  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_type_symbol(this);
  }
}
