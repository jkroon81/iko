/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.SquareRootMethod : Method {
	public SquareRootMethod() {
		Object(name : "sqrt", data_type : new RealType());
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_square_root_method(this);
	}
}
