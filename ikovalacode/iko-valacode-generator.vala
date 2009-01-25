/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.ValaCode.Generator : Iko.AST.Visitor {
  bool in_comment;
  bool newline;
  int  indent;
  char prev;

  public unowned FileStream file { private get; set; default = stdout; }

  public int indent_size { private get; set; default = 2; }

  construct {
    in_comment = false;
    newline    = true;
    indent     = 0;
    prev       = 0;
  }

  void write(string str) {
    char *c = (char*) str;

    while(*c != 0) {
      switch(*c) {
      case '*':
        file.printf("*");
        if(prev == '/')
          in_comment = true;
        break;
      case '/':
        file.printf("/");
        if(prev == '*') {
          in_comment = false;
          file.printf("\n");
          newline = true;
        }
        break;
      case '{':
        file.printf("{\n");
        newline = true;
        indent += indent_size;
        break;
      case '}':
        indent -= indent_size;
        file.printf("\n%s}", string.nfill(indent, ' '));
        newline = false;
        break;
      case ';':
        file.printf(";\n");
        newline = true;
        break;
      default:
        if(newline)
          file.printf("%s", string.nfill(indent, ' '));
        file.printf("%c", *c);
        newline = false;
        break;
      }
      prev = *c;
      c++;
    }
  }

  void write_comment(string str) {
    write("/* " + str + " */");
  }

  void write_string_literal(string str) {
    write("\"" + str + "\"");
  }

  public override void visit_system(Iko.AST.System system) {
    write_comment("Generated by %s, do not modify".printf(Environment.get_prgname()));
    var states = system.get_states();
    write("static string[%u] x_name = {".printf(states.size));
    foreach(var s in states) {
      write_string_literal(s.name);
      if(s != states[states.size - 1])
        write(",");
    }
    write("};");
    write("static double[%u] x;".printf(states.size));
  }
}
