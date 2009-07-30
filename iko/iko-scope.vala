/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.Scope : Object {
  HashTable<string, Symbol> bank;

  public Symbol symbol { get; construct; }

  public Scope(Symbol symbol) {
    this.symbol = symbol;
  }

  construct {
    bank = new HashTable<string, Symbol>(str_hash, str_equal);
  }

  public void add(Symbol sym) {
    assert(sym.parent == null);
    bank.insert(sym.name, sym);
    sym.parent = symbol;
  }

  public Symbol? lookup(string name) {
    return bank.lookup(name);
  }
}
