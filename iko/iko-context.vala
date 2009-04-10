/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.Context : Node {
  ArrayList<SourceFile> source_files;

  public Namespace root { get; private set; }

  construct {
    source_files = new ArrayList<SourceFile>();
    root = new Namespace(null, "Root");
    root.add_type(new FloatType());
    root.add_type(new IntegerType());
    root.add_type(new RealType());
    root.add_method(new DerivativeMethod());
    root.add_method(new SquareRootMethod());
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_context(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    root.accept(v);
    foreach(var sf in source_files)
      sf.accept(v);
  }

  public void add_source_file(SourceFile sf) {
    source_files.add(sf);
  }
}
