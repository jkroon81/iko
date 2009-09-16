/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Transformer.Main {
  public static int main(string[] args) {
    Environment.set_prgname("transformer");

    if(args.length == 1) {
      stdout.printf("Usage: transformer <expr>\n");
      return 0;
    }

    var context = new Iko.Context();
    var parser = new Iko.Parser();
    string src = "real A,B,C,D,E,F; model { %s = %s; }".printf(args[1], args[1]);
    parser.parse_source_string(context, src);
    if(Iko.Report.n_errors > 0)
      return -1;
    context.accept(new Iko.TypeResolver());
    if(Iko.Report.n_errors > 0)
      return -1;
    context.accept(new Iko.MemberResolver());
    if(Iko.Report.n_errors > 0)
      return -1;

    var system = new Iko.AST.System();
    context.accept(new Iko.AST.Generator(system));
    context = null;

    assert(system.equations.size == 1);
    var writer = new Iko.AST.Writer();
    foreach(var e in system.equations) {
      var expr = e.left as Iko.AST.Expression;
      stdout.printf("original           : %s\n", writer.generate_string(expr));
      expr = new Iko.AST.LevelOperators().transform(expr);
      stdout.printf("level operators    : %s\n", writer.generate_string(expr));
      expr = new Iko.AST.SimplifyPowers().transform(expr);
      stdout.printf("simplify powers    : %s\n", writer.generate_string(expr));
      expr = new Iko.AST.SimplifyRationals().transform(expr);
      stdout.printf("simplify rationals : %s\n", writer.generate_string(expr));
      expr = new Iko.AST.ExpandSymbols().transform(expr);
      stdout.printf("expand symbols     : %s\n", writer.generate_string(expr));
      expr = new Iko.AST.CollectSymbols().transform(expr);
      stdout.printf("collect symbols    : %s\n", writer.generate_string(expr));
      expr = new Iko.AST.FoldConstants().transform(expr);
      stdout.printf("fold constants     : %s\n", writer.generate_string(expr));
      stdout.printf("\n");
    }

    return 0;
  }
}
