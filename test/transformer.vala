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
    for(i = 1; i < args.length; i++)
      context.source_files.add(new Iko.SourceFile(args[i]));
    context.accept(new Iko.Parser());
    context.accept(new Iko.TypeResolver());
    context.accept(new Iko.MemberResolver());

    var system = new Iko.AST.System();
    context.accept(new Iko.AST.Generator(system));
    context = null;

    var writer = new Iko.AST.Writer();
    foreach(var e in system.equations) {
      var expr = e as Iko.AST.Expression;
      stdout.printf("original :            ");
      expr.accept(writer);
      stdout.printf("\ntransform negatives : ");
      expr = new Iko.AST.TransformNegatives().transform(expr);
      expr.accept(writer);
      stdout.printf("\nlevel operators :     ");
      expr = new Iko.AST.LevelOperators().transform(expr);
      expr.accept(writer);
      stdout.printf("\nsimplify rationals :  ");
      expr = new Iko.AST.SimplifyRationals().transform(expr);
      expr.accept(writer);
      stdout.printf("\nexpand terms :        ");
      expr = new Iko.AST.ExpandTerms().transform(expr);
      expr.accept(writer);
      stdout.printf("\ncollect terms :       ");
      expr = new Iko.AST.CollectTerms().transform(expr);
      expr.accept(writer);
    }

    return 0;
  }
}
