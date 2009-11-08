/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.FloatType : TypeSymbol {
	public FloatType() {
		name = "float";
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_float_type(this);
	}
}
