/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.Literal : Expression {
  public string   value        { get; construct; }
  public DataType literal_type { private get; construct; }

  public override DataType data_type { get { return literal_type; } }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_literal(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    literal_type.accept(v);
  }
}
