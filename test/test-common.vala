/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace TestCommon {
  const string RESET = "\033[m";
  const string RED   = "\033[1;31m";
  const string GREEN = "\033[1;32m";

  public static int test(string left, string right) {
    int retval;

    var context = new Iko.Context();
    var parser = new Iko.Parser();
    string src = "real A,B,C,D,E,F; model { %s = %s; }".printf(left, right);
    parser.parse_source_string(context, src);
    context.accept(new Iko.TypeResolver());
    context.accept(new Iko.MemberResolver());

    var system = new Iko.AST.System();
    context.accept(new Iko.AST.Generator(system));
    context = null;

    assert(system.equations.size == 1);
    var writer = new Iko.AST.Writer();
    var left_gen = writer.generate_string(system.equations[0].left.simplify());
    var right_gen = writer.generate_string(system.equations[0].right.simplify());
    if(left_gen != right_gen) {
      stdout.printf(RED + "FAIL" + RESET);
      retval = 1;
    } else {
      stdout.printf(GREEN + "PASS" + RESET);
      retval = 0;
    }
    stdout.printf(" %s = %s [ %s = %s ]\n", left, right, left_gen, right_gen);
    return retval;
  }
}
