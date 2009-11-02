/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.Scope : Object {
	HashTable<string, Symbol> map;

	public Symbol symbol { get; construct; }

	public Scope(Symbol symbol) {
		Object(symbol : symbol);
	}

	construct {
		map = new HashTable<string, Symbol>(str_hash, str_equal);
	}

	public void add(Symbol sym) {
		assert(sym.parent == null);
		assert(map.lookup(sym.name) == null);

		sym.parent = symbol;
		map.insert(sym.name, sym);
	}

	public Symbol? lookup(string name) {
		return map.lookup(name);
	}
}
