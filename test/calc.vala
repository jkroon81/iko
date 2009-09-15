/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Calc.Main {
  public static int main(string[] args) {
    Environment.set_prgname("calc");

    if(args.length == 1) {
      stdout.printf("Usage: calc <expr>\n");
      return 0;
    }

    var context = new Iko.Context();
    var parser = new Iko.Parser();
    string src = "real A,B,C,D,E,F; model { %s = %s; }".printf(args[1], args[1]);
    parser.parse_source_string(context, src);
    context.accept(new Iko.TypeResolver());
    context.accept(new Iko.MemberResolver());

    var system = new Iko.AST.System();
    context.accept(new Iko.AST.Generator(system));
    context = null;

    assert(system.equations.size == 1);
    stdout.printf("%s\n", new Iko.AST.Writer().generate_string(system.equations[0].left.simplify()));
    return 0;
  }
}
