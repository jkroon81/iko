/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.Matrix : Object {
	public uint n_rows    { get; construct; }
	public uint n_columns { get; construct; }

	Expression[] expr;

	public Matrix(uint n_rows, uint n_columns) {
		this.n_rows    = n_rows;
		this.n_columns = n_columns;
	}

	construct {
		expr = new Expression[n_rows * n_columns];
		for(int i = 0; i < n_rows * n_columns; i++)
			expr[i] = IntegerLiteral.ZERO;
	}

	public new Expression get(uint i, uint j) {
		assert(i < n_rows);
		assert(j < n_columns);
		return expr[i * n_columns + j];
	}

	public new void set(uint i, uint j, Expression expr) {
		assert(i < n_rows);
		assert(j < n_columns);
		this.expr[i * n_columns + j] = expr;
	}
}
