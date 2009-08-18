/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using TestCommon;

public class TestPower.Main {
  public static int main() {
    int n_errors = 0;

    Environment.set_prgname("test-power");

    n_errors += test("real A; model { A^0 = 1; }", "1=1");
    n_errors += test("real A, B; model { A^-B = 0; }", "1/A^B=0");
    n_errors += test("real A, B, C; model { A^B * A^C = 0; }", "A^(B+C)=0");
    n_errors += test("real A, B, C; model { ( A^B )^C = 0; }", "A^(B*C)=0");
    n_errors += test("real A, B, C; model { A^B * C^B = 0; }", "(A*C)^B=0");
    return n_errors;
  }
}
