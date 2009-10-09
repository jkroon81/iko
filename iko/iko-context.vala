/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.Context : Node {
  public Namespace root { get; private set; }

  construct {
    root = new Namespace(null, "(root)");
    try {
      root.add_type(new FloatType());
      root.add_type(new IntegerType());
      root.add_type(new RealType());
      root.add_method(new DerivativeMethod());
      root.add_method(new SquareRootMethod());
    } catch(ParseError e) {
      assert_not_reached();
    }
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_context(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    root.accept(v);
  }
}
