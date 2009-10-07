/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

int main(string[] args) {
  Environment.set_prgname("ish");

  var context = new Iko.Context();
  var parser = new Iko.Parser();
  var system = new Iko.AST.System();

  while(true) {
    stdout.printf("> ");
    var line = stdin.read_line();
    if(line == null)
      break;
    switch(line) {
    case "clear":
      context = new Iko.Context();
      system = new Iko.AST.System();
      break;
    case "dump":
      stdout.printf(new Iko.Writer().generate_string(context));
      stdout.printf(new Iko.AST.Writer().generate_string(system));
      break;
    default:
      parser.parse_source_string(context, line);
      context.accept(new Iko.TypeResolver());
      context.accept(new Iko.MemberResolver());
      system = new Iko.AST.Generator().generate_system(context);
      break;
    }
  }
  stdout.printf("\n");

  return 0;
}
