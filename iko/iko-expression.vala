/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.Expression : Node {
  public abstract DataType data_type { get; }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_expression(this);
  }
}
