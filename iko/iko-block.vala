/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.Block : Node {
  public SList<Statement> statements;

  public Block(SourceReference? src) {
    this.src = src;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_block(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    foreach(var stmt in statements)
      stmt.accept(v);
  }
}
