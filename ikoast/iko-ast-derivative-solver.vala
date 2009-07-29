/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.DerivativeSolver : Visitor {
  public override void visit_system(System s) {
    foreach(var eq in s.equations)
      eq.simplify();
  }
}
