/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.Block : Node {
  ArrayList<Statement> statements;

  public Block(SourceReference? src) {
    this.src = src;
  }

  construct {
    statements = new ArrayList<Statement>();
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

  public void add_statement(Statement stmt) {
    statements.add(stmt);
  }
}
