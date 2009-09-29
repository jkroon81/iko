/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.MatrixExpression : Expression {
  public Matrix matrix { get; construct; }

  public MatrixExpression(Matrix matrix) {
    this.matrix = matrix;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_matrix_expression(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    for(int i = 0; i < matrix.n_rows; i++)
      for(int j = 0; j < matrix.n_columns; j++)
        matrix.get(i,j).accept(v);
  }
}
