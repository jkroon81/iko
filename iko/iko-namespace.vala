/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.Namespace : Symbol {
  Model?                model;
  ArrayList<Field>      fields;
  ArrayList<Method>     methods;
  ArrayList<Namespace>  namespaces;
  ArrayList<TypeSymbol> types;

  public Namespace(SourceReference? src, string name) {
    this.src  = src;
    this.name = name;
  }

  construct {
    fields     = new ArrayList<Field>();
    methods    = new ArrayList<Method>();
    namespaces = new ArrayList<Namespace>();
    types      = new ArrayList<TypeSymbol>();
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_namespace(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    if(model != null)
      model.accept(v);
    foreach(var f in fields)
      f.accept(v);
    foreach(var m in methods)
      m.accept(v);
    foreach(var ns in namespaces)
      ns.accept(v);
    foreach(var t in types)
      t.accept(v);
  }

  public void add_field(Field f) {
    if(scope.lookup(f.name) != null)
      Report.error(f.src, "'%s' is already defined in '%s'".printf(f.name, name));
    else {
      fields.add(f);
      scope.add(f);
    }
  }

  public void add_method(Method m) {
    if(scope.lookup(m.name) != null)
      Report.error(m.src, "'%s' is already defined in '%s'".printf(m.name, name));
    else {
      methods.add(m);
      scope.add(m);
    }
  }

  public void add_namespace(Namespace ns) {
    if(scope.lookup(ns.name) != null) {
      if(scope.lookup(ns.name) is Namespace) {
        var old_ns = (Namespace) scope.lookup(ns.name);
        foreach(var sub_ns in ns.namespaces)
          old_ns.add_namespace(sub_ns);
        foreach(var type in ns.types)
          old_ns.add_type(type);
      } else
        Report.error(ns.src, "'%s' is already defined in '%s'".printf(ns.name, name));
    } else {
      namespaces.add(ns);
      scope.add(ns);
    }
  }

  public void add_type(TypeSymbol t) {
    if(scope.lookup(t.name) != null)
      Report.error(t.src, "'%s' is already defined in '%s'".printf(t.name, name));
    else {
      types.add(t);
      scope.add(t);
    }
  }

  public void set_model(Model model) {
    if(this.model != null)
      Report.error(model.src, "model already defined");
    else
      this.model = model;
  }

  public ReadOnlyList<Field> get_fields() {
    return new ReadOnlyList<Field>(fields);
  }

  public ReadOnlyList<Method> get_methods() {
    return new ReadOnlyList<Method>(methods);
  }

  public ReadOnlyList<Namespace> get_namespaces() {
    return new ReadOnlyList<Namespace>(namespaces);
  }

  public ReadOnlyList<TypeSymbol> get_types() {
    return new ReadOnlyList<TypeSymbol>(types);
  }

  public Model? get_model() {
    return model;
  }
}
