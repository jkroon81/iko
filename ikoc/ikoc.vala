/*
 * Ikoc - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Ikoc.Main {
  public static int main(string[] args) {
    int i;

    if(args.length == 1) {
      stdout.printf("Usage: ikoc <filename>\n");
      return 0;
    }

    Environment.set_prgname("ikoc");

    var context = new Iko.Context();
    for(i = 1; i < args.length; i++)
      context.add_source_file(new Iko.SourceFile(args[i]));

    context.accept(new Iko.Parser());
    context.accept(new Iko.TypeResolver());
    context.accept(new Iko.MemberResolver());

    var system = new Iko.AST.System();
    context.accept(new Iko.AST.Generator(system));
    context = null;

    system.accept(new Iko.AST.DerivativeSolver());
    var codegen = new Iko.ValaCode.Generator();
    system.accept(codegen);

    return 0;
  }
}
