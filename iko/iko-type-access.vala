/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.TypeAccess : DataType {
  public DataType?  inner       { get; construct; }
  public TypeSymbol type_symbol { get; set construct; }

  public override Scope scope { get { return type_symbol.scope; } }

  public TypeAccess(SourceReference? src, DataType? inner, TypeSymbol type_symbol) {
    this.src         = src;
    this.inner       = inner;
    this.type_symbol = type_symbol;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_type_access(this);
  }
}
