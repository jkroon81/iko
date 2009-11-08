/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.Method : Member {
	public SList<Parameter> params;

	public Method(SourceReference? src, Member.Binding binding, DataType data_type, string name) {
		this.src       = src;
		this.binding   = binding;
		this.data_type = data_type;
		this.name      = name;
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_method(this);
	}

	public override void accept_children(Visitor v) {
		base.accept_children(v);
		foreach(var p in params)
			p.accept(v);
	}

	public void add_parameter(Parameter p) throws ParseError {
		if(scope.lookup(p.name) != null)
			throw new ParseError.SYNTAX("%s:'%s' is already defined in '%s'".printf(p.src.to_string(), p.name, name));
		else {
			params.prepend(p);
			scope.add(p);
		}
	}
}
