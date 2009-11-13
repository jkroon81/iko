/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Real : AtomicExpression {
	public string value { get; construct; }

	public Real(string value) {
		Object(value : value);
	}
}
