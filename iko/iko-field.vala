/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.Field : Member {
  ArrayList<Expression> params;

  public Field(SourceReference? src, Member.Binding binding, DataType data_type, string name) {
    this.src       = src;
    this.binding   = binding;
    this.data_type = data_type;
    this.name      = name;
  }

  construct {
    params = new ArrayList<Expression>();
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

  public void add_parameter(Expression param) {
    params.add(param);
  }

  public ReadOnlyList<Expression> get_parameters() {
    return new ReadOnlyList<Expression>(params);
  }
}
