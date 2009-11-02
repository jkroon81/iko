/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.DerivativeMethod : Method {
	public DerivativeMethod() {
		Object(
			name      : "der",
			visible   : false,
			binding   : Member.Binding.STATIC,
			data_type : new TypeAccess(null, null, new UnresolvedType(null, "real"))
		);
	}

	construct {
		var real_type = new TypeAccess(null, null, new UnresolvedType(null, "real"));
		try {
			add_parameter(new Parameter(null, real_type, "symbol"));
			add_parameter(new Parameter(null, real_type, "param"));
		} catch(ParseError e) {
			assert_not_reached();
		}
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_derivative_method(this);
	}
}
