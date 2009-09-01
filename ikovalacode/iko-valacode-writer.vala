/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.ValaCode.Writer : Iko.AST.Visitor {
  StringBuilder buffer;
  bool          in_comment;
  bool          newline;
  int           indent;
  char          prev;

  public int indent_size { private get; set; default = 2; }

  construct {
    buffer     = new StringBuilder();
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
        buffer.append_c('*');
        if(prev == '/')
          in_comment = true;
        break;
      case '/':
        buffer.append_c('/');
        if(prev == '*') {
          in_comment = false;
          buffer.append_c('\n');
          newline = true;
        }
        break;
      case '{':
        buffer.append("{\n");
        newline = true;
        indent += indent_size;
        break;
      case '}':
        indent -= indent_size;
        buffer.append_printf("\n%s}", string.nfill(indent, ' '));
        newline = false;
        break;
      case ';':
        buffer.append(";\n");
        newline = true;
        break;
      default:
        if(newline)
          buffer.append(string.nfill(indent, ' '));
        buffer.append_c(*c);
        newline = false;
        break;
      }
      prev = *c;
      c++;
    }
  }

  public string generate_string(Iko.AST.Node n) {
    buffer.truncate(0);
    n.accept(this);
    return buffer.str;
  }

  void write_comment(string str) {
    write("/* " + str + " */");
  }

  void write_string_literal(string str) {
    write("\"" + str + "\"");
  }

  public override void visit_system(Iko.AST.System system) {
    write_comment("Generated by %s, do not modify".printf(Environment.get_prgname()));
    write("static string[%u] x_name = {".printf(system.states.size));
    for(int i = 0; i < system.states.size; i++) {
      write_string_literal(system.states[i].name);
      if(i != system.states.size - 1)
        write(",");
    }
    write("};");
    write("static double[%u] x;".printf(system.states.size));
  }
}
