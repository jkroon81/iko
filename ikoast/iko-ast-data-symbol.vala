/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.AST.DataSymbol : Symbol {
  public DataType data_type { get; construct; }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_data_symbol(this);
  }
}
