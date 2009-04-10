/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.SourceFile : Node {
  public string filename { get; construct; }

  public SourceFile(string filename) {
    this.filename = filename;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_source_file(this);
  }
}
