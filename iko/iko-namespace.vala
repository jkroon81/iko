/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.Namespace : Symbol {
  public SList<Equation>   equations;
  public SList<Field>      fields;
  public SList<Method>     methods;
  public SList<Namespace>  namespaces;
  public SList<TypeSymbol> types;

  public Namespace(SourceReference? src, string name) {
    this.src  = src;
    this.name = name;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_namespace(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    foreach(var e in equations)
      e.accept(v);
    foreach(var f in fields)
      f.accept(v);
    foreach(var m in methods)
      m.accept(v);
    foreach(var ns in namespaces)
      ns.accept(v);
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

  public void add_namespace(Namespace ns) throws ParseError {
    if(scope.lookup(ns.name) != null) {
      if(scope.lookup(ns.name) is Namespace) {
        var old_ns = (Namespace) scope.lookup(ns.name);
        foreach(var sub_ns in ns.namespaces)
          old_ns.add_namespace(sub_ns);
        foreach(var type in ns.types)
          old_ns.add_type(type);
      } else
        throw new ParseError.SYNTAX("%s:'%s' is already defined in '%s'".printf(ns.src.to_string(), ns.name, name));
    } else {
      namespaces.prepend(ns);
      scope.add(ns);
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
