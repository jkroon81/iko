/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using TestCommon;

public class TestAlgebra.Main {
  public static int main() {
    int n_errors = 0;

    Environment.set_prgname("test-algebra");

    n_errors += test("real A, B; model { B + A = 0; }", "A+B=0");
    n_errors += test("real A, B; model { B * A = 0; }", "A*B=0");
    n_errors += test("real A, B, C; model { ( A + B ) + C = 0; }", "A+B+C=0");
    n_errors += test("real A, B, C; model { ( A * B ) * C = 0; }", "A*B*C=0");
    n_errors += test("real A, B, C; model { ( A + B ) * C = 0; }", "A*C+B*C=0");
    n_errors += test("real A, B; model { A + 0 = 0; }", "A=0");
    n_errors += test("real A, B; model { A * 0 = 0; }", "0=0");
    n_errors += test("real A, B; model { A * 1 = 0; }", "A=0");
    return n_errors;
  }
}
