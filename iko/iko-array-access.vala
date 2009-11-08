/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.ArrayAccess : Expression {
	public Expression array { get; construct; }
	public Expression index { get; construct; }

	public override DataType data_type { get { return array.data_type; } }

	public ArrayAccess(SourceReference? src, Expression array, Expression index) {
		this.src   = src;
		this.array = array;
		this.index = index;
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_array_access(this);
	}

	public override void accept_children(Visitor v) {
		base.accept_children(v);
		array.accept(v);
		index.accept(v);
	}
}
