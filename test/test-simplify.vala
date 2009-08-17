/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using TestCommon;

public class TestSimplify.Main {
  public static int main() {
    int n_errors = 0;

    Environment.set_prgname("test-simplify");

    n_errors += test("real A; model { -A = 0; }", "A=0");
    n_errors += test("real A, B; model { A - B = 0; }", "A-B=0");
    n_errors += test("real A, B, C; model { ( A + B ) + C = 0; }", "A+B+C=0");
    n_errors += test("real A, B, C; model { ( A * B ) * C = 0; }", "A*B*C=0");
    n_errors += test("real A, B, C, D; model { A + B + C + D = 0; }", "A+B+C+D=0");
    n_errors += test("real A, B, C, D; model { ( ( ( A + B ) + C ) + D ) = 0; }", "A+B+C+D=0");
    n_errors += test("real A, B, C, D; model { ( A + B ) + ( C + D ) = 0; }", "A+B+C+D=0");
    n_errors += test("real A, B, C; model { ( A / B ) / C = 0; }", "A/(B*C)=0");
    n_errors += test("real A, B, C; model { A / ( B / C ) = 0; }", "(A*C)/B=0");
    n_errors += test("real A, B, C; model { A * ( B / C ) = 0; }", "(A*B)/C=0");
    n_errors += test("real A, B, C, D, E, F; model { A * ( B / C ) * ( D / E ) = 0; }",
                     "(A*B*D*F)/(C*E)=0");
    return n_errors;
  }
}
