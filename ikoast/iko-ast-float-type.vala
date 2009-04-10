/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.FloatType : DataType {
  public FloatType() {
    name = "float";
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_float_type(this);
  }
}
