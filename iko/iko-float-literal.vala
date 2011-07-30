/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.FloatLiteral : Literal {
	public FloatLiteral(SourceReference? src, string value) {
		Object(
			src          : src,
			value        : value,
			literal_type : new TypeAccess(null, null, new UnresolvedType(null, "float"))
		);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_float_literal(this);
	}
}
