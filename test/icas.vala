/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

static string[] db;
static int list_index = 0;
static int len = 0;

static string? compl_func(string text, int state) {
	string name;

	if(state == 0) {
		Readline.completion_append_character = '(';
		list_index = 0;
		len = text.length;
	}

	while((name = db[list_index++]) != null)
		if(Posix.strncmp(name, text, len) == 0)
			return name;

	return null;
}

class Session : Object {
	public HashTable<string, Iko.CAS.Expression> variable { get; construct; }

	construct {
		variable = new HashTable<string, Iko.CAS.Expression>(str_hash, str_equal);
	}

	public Iko.CAS.Expression eval(Iko.CAS.Expression e) throws Iko.CAS.Error {
		var x = e;
		foreach(var v in variable.get_keys())
			x = Iko.CAS.Library.subs(x, new Iko.CAS.Symbol(v), variable[v]);
		return x;
	}
}

int main(string[] args) {
	Environment.set_prgname("icas");
	Iko.CAS.Library.init();
	db = Iko.CAS.Library.get_functions();
	var parser = new Iko.CAS.Parser();
	var session = new Session();

	Readline.basic_word_break_characters ="0123456789+-*/^()[],. ";
	Readline.bind_key('\t', Readline.complete);
	Readline.completion_entry_function = compl_func;
	Readline.variable_bind("show-all-if-unmodified", "on");

	while(true) {
		var line = Readline.readline("> ");
		if(line == null) {
			stdout.putc('\n');
			break;
		}
		switch(line) {
		case "":
			break;
		case "clear":
			session.variable.remove_all();
			break;
		case "who":
			foreach(var v in session.variable.get_keys())
				stdout.printf(v + "\n");
			break;
		default:
			if(line[0] != 0) {
				try {
					string name;
					Iko.CAS.Expression expr;

					try {
						parser.set_source_from_text(line + ";");
						var a = parser.parse_assignment();
						parser.expect(Iko.CAS.TokenType.EOF);
						name = a.symbol.name;
						expr = a.expr;
					} catch(Iko.CAS.Error e) {
						try {
							parser.set_source_from_text(line);
							name = "Ans";
							expr = parser.parse_expression();
							parser.expect(Iko.CAS.TokenType.EOF);
							if(expr is Iko.CAS.Symbol) {
								var s = expr as Iko.CAS.Symbol;
								if(session.variable[s.name] != null) {
									name = s.name;
									expr = session.variable[s.name];
								}
							}
						} catch(Iko.CAS.Error e) {
							throw e;
						}
					}
					expr = session.eval(expr);
					expr = Iko.CAS.Library.simplify(expr);
					session.variable[name] = expr;
					stdout.printf("\n%s = %s\n\n", name, expr.to_string());
				} catch(Iko.CAS.Error e) {
					stdout.printf(e.message);
				}
				Readline.History.add(line);
			}
			break;
		}
	}

	return 0;
}
