/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.DataType : Node {
  public abstract Scope scope { get; }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_data_type(this);
  }
}
