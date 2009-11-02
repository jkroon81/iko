/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.Method : DataSymbol {
	public Method(string name, DataType data_type) {
		Object(name : name, data_type : data_type);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_method(this);
	}
}
