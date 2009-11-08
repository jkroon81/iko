/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.Class : TypeSymbol {
	public SList<Equation>   equations;
	public SList<Field>      fields;
	public SList<Method>     methods;
	public SList<TypeSymbol> types;

	public Class(SourceReference? src, string name) {
		this.src  = src;
		this.name = name;
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_class(this);
	}

	public override void accept_children(Visitor v) {
		base.accept_children(v);
		foreach(var e in equations)
			e.accept(v);
		foreach(var f in fields)
			f.accept(v);
		foreach(var m in methods)
			m.accept(v);
		foreach(var t in types)
			t.accept(v);
	}

	public void add_field(Field f) throws ParseError {
		if(scope.lookup(f.name) != null)
			throw new ParseError.SYNTAX("%s:'%s' is already defined in '%s'".printf(f.src.to_string(), f.name, name));
		else {
			fields.prepend(f);
			scope.add(f);
		}
	}

	public void add_method(Method m) throws ParseError {
		if(scope.lookup(m.name) != null)
			throw new ParseError.SYNTAX("%s:'%s' is already defined in '%s'".printf(m.src.to_string(), m.name, name));
		else {
			methods.prepend(m);
			scope.add(m);
		}
	}

	public void add_type(TypeSymbol t) throws ParseError {
		if(scope.lookup(t.name) != null)
			throw new ParseError.SYNTAX("%s:'%s' is already defined in '%s'".printf(t.src.to_string(), t.name, name));
		else {
			types.prepend(t);
			scope.add(t);
		}
	}
}
