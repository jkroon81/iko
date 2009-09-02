/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Transformer.Main {
  public static int main(string[] args) {
    int i;

    if(args.length == 1) {
      stdout.printf("Usage: transformer <filename>\n");
      return 0;
    }

    Environment.set_prgname("transformer");

    var context = new Iko.Context();
    var parser = new Iko.Parser();
    for(i = 1; i < args.length; i++)
      parser.parse_source_file(context, args[i]);
    context.accept(new Iko.TypeResolver());
    context.accept(new Iko.MemberResolver());

    var system = new Iko.AST.System();
    context.accept(new Iko.AST.Generator(system));
    context = null;

    var writer = new Iko.AST.Writer();
    foreach(var e in system.equations) {
      var expr = e as Iko.AST.Expression;
      stdout.printf("original            : %s\n", writer.generate_string(expr));
      expr = new Iko.AST.LevelOperators().transform(expr);
      stdout.printf("level operators     : %s\n", writer.generate_string(expr));
      expr = new Iko.AST.SimplifyRationals().transform(expr);
      stdout.printf("simplify rationals  : %s\n", writer.generate_string(expr));
      expr = new Iko.AST.ExpandTerms().transform(expr);
      stdout.printf("expand terms        : %s\n", writer.generate_string(expr));
      expr = new Iko.AST.CollectTerms().transform(expr);
      stdout.printf("collect terms       : %s\n", writer.generate_string(expr));
      stdout.printf("\n");
    }

    return 0;
  }
}
