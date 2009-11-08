/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.IntegerType : TypeSymbol {
	public IntegerType() {
		name = "int";
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_integer_type(this);
	}
}
