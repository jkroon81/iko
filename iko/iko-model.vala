/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.Model : Node {
  Block block;

  public Model(SourceReference? src, Block block) {
    this.src   = src;
    this.block = block;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_model(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    block.accept(v);
  }
}
