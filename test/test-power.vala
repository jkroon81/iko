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

    n_errors += test("A^0", "1");
    n_errors += test("A^1", "A");
    n_errors += test("A^-B", "1/A^B");
    n_errors += test("A^B * A^C", "A^(B+C)");
    n_errors += test("(A^B)^C", "A^(B*C)");
    n_errors += test("A^B * C^B", "(A*C)^B");
    return n_errors;
  }
}
