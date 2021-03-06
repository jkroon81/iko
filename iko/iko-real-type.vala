/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.RealType : Class {
	public RealType() {
		Object(name : "real", visible : false);
	}

	construct {
		var float_type = new TypeAccess(null, null, new UnresolvedType(null, "float"));
		try {
			add_field(new Field(null, Member.Binding.INSTANCE, float_type, "initial"));
			add_field(new Field(null, Member.Binding.INSTANCE, float_type, "final"));
		} catch(ParseError e) {
			assert_not_reached();
		}
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_real_type(this);
	}
}
