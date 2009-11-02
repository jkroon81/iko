/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.Field : Member {
	public SList<Expression> params;

	public Field(SourceReference? src, Member.Binding binding, DataType data_type, string name) {
		Object(src : src, binding : binding, data_type : data_type, name : name);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_field(this);
	}

	public override void accept_children(Visitor v) {
		base.accept_children(v);
		foreach(var p in params)
			p.accept(v);
	}
}
