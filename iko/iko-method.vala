/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.Method : Member {
  ArrayList<Parameter> params;

  public Method(SourceReference? src, Member.Binding binding, DataType data_type, string name) {
    this.src       = src;
    this.binding   = binding;
    this.data_type = data_type;
    this.name      = name;
  }

  construct {
    params = new ArrayList<Parameter>();
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

  public void add_parameter(Parameter p) {
    if(scope.lookup(p.name) != null)
      Report.error(p.src, "'%s' is already defined in '%s'".printf(p.name, name));
    else {
      params.add(p);
      scope.add(p);
    }
  }

  public ReadOnlyList<Parameter> get_parameters() {
    return new ReadOnlyList<Parameter>(params);
  }
}
