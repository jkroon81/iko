/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.IntegerLiteral : Literal {
  public IntegerLiteral(SourceReference? src, string value) {
    this.src   = src;
    this.value = value;
    literal_type = new TypeAccess(null, null, new UnresolvedType(null, "int"));
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_integer_literal(this);
  }
}
