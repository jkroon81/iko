/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using TestCommon;

public class TestMultiplication.Main {
  public static int main() {
    int n_errors = 0;

    Environment.set_prgname("test-multiplication");

    n_errors += test("A * B", "B * A");
    n_errors += test("( A * B ) * C", "A * ( B * C )");
    n_errors += test("A * ( B + C )", "A * B + A * C");
    n_errors += test("A * 1", "A");
    n_errors += test("A * 0", "0");
    n_errors += test("A * ( 1 / A )", "1");
    n_errors += test("(-1) * A", "-A");
    n_errors += test("(-1) * (-1)", "1");
    n_errors += test("( A + B )^2", "A^2 + 2 * A * B + B^2");
    n_errors += test("( A - B )^2", "A^2 - 2 * A * B + B^2");
    n_errors += test("( A + B ) * ( A - B )", "A^2 - B^2");
    n_errors += test("( A + B )^3", "A^3 + 3 * A^2 * B + 3 * A * B^2 + B^3");
    return n_errors;
  }
}