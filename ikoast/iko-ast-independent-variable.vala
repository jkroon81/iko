/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.IndependentVariable : DataSymbol {
  public IndependentVariable(string name, DataType data_type) {
    this.name      = name;
    this.data_type = data_type;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_independent_variable(this);
  }
}
