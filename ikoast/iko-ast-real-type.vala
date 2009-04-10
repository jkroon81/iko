/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.RealType : DataType {
  public RealType() {
    name = "real";
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_real_type(this);
  }
}
