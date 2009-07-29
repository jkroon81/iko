/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.ArrayType : DataType {
  public DataType   element_type { get; construct; }
  public Expression length       { get; construct; }

  public override Scope scope { get { return element_type.scope; } }

  public ArrayType(SourceReference? src, DataType element_type, Expression length) {
    this.src          = src;
    this.element_type = element_type;
    this.length       = length;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_array_type(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    element_type.accept(v);
    length.accept(v);
  }
}
