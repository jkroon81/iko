/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.Parameter : DataSymbol {
  public Parameter(SourceReference? src, DataType data_type, string name) {
    this.src       = src;
    this.data_type = data_type;
    this.name      = name;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_parameter(this);
  }
}
