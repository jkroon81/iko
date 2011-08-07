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

int main(string[] args) {
	Environment.set_prgname("icas");
	Iko.CAS.Library.init();
	db = Iko.CAS.Library.get_functions();
	var parser = new Iko.CAS.Parser();

	Readline.basic_word_break_characters ="0123456789+-*/^()[],. ";
	Readline.bind_key('\t', Readline.complete);
	Readline.completion_entry_function = compl_func;
	Readline.variable_bind("show-all-if-unmodified", "on");

	while(true) {
		var line = Readline.readline("> ");
		if(line == "exit" || line == null)
			break;
		var expr = parser.parse_source_string(line);
		stdout.printf("%s\n", expr.eval().to_string());
		Readline.History.add(line);
	}

	return 0;
}
