/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.Class : TypeSymbol {
  Model?                model;
  ArrayList<Field>      fields;
  ArrayList<Method>     methods;
  ArrayList<TypeSymbol> types;

  public Class(SourceReference? src, string name) {
    this.src  = src;
    this.name = name;
  }

  construct {
    fields  = new ArrayList<Field>();
    methods = new ArrayList<Method>();
    types   = new ArrayList<TypeSymbol>();
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_class(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    if(model != null)
      model.accept(v);
    foreach(var f in fields)
      f.accept(v);
    foreach(var m in methods)
      m.accept(v);
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

  public ReadOnlyList<TypeSymbol> get_types() {
    return new ReadOnlyList<TypeSymbol>(types);
  }

  public Model? get_model() {
    return model;
  }
}
