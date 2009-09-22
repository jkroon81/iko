/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using TestCommon;

int main() {
  int n_errors = 0;

  Environment.set_prgname("test-constant-folding");

  n_errors += test("3 + 4", "7");
  n_errors += test("3 - 4", "-1");
  n_errors += test("3 * 4", "12");
  n_errors += test("3 / 4", "0.75");
  return n_errors;
}
