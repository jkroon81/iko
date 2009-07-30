/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.DerivativeMethod : Method {
  public DerivativeMethod() {
    this.name      = "der";
    this.data_type = new RealType();
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_derivative_method(this);
  }
}
