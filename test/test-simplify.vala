/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class TestSimplify.Main {
  const string RESET = "\033[m";
  const string RED   = "\033[1;31m";
  const string GREEN = "\033[1;32m";

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

  static int test(string src, string text_ref) {
    var context = new Iko.Context();
    var parser = new Iko.Parser();
    parser.parse_source_string(context, src);
    context.accept(new Iko.TypeResolver());
    context.accept(new Iko.MemberResolver());

    var system = new Iko.AST.System();
    context.accept(new Iko.AST.Generator(system));
    context = null;

    assert(system.equations.size == 1);
    var writer = new Iko.AST.Writer();
    var text_gen = writer.generate_string(system.equations[0].simplify());
    if(text_gen != text_ref) {
      stdout.printf(RED + "FAIL" + RESET + " %s " + RED + "!=" + RESET + " %s\n", text_gen, text_ref);
      return 1;
    } else {
      stdout.printf(GREEN + "PASS" + RESET + " %s " + GREEN + "==" + RESET + " %s\n", text_gen, text_ref);
      return 0;
    }
  }
}
