/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.SymbolAccess : SimpleExpression {
  public Symbol symbol { get; construct; }

  public SymbolAccess(Symbol symbol) {
    this.symbol = symbol;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_symbol_access(this);
  }
}
