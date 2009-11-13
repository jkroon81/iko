/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Symbol : AtomicExpression {
	public string name { get; construct; }

	public Symbol(string name) {
		Object(name : name);
	}
}
