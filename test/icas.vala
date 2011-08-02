/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

int main(string[] args) {
	Environment.set_prgname("icas");
	Iko.CAS.init();
	var parser = new Iko.CAS.Parser();
	Readline.bind_key('\t', Readline.abort);

	while(true) {
		var line = Readline.readline("> ");
		if(line == "exit" || line == null)
			break;
		var expr = parser.parse_source_string(line);
		stdout.printf("%s\n", new Iko.CAS.Writer().generate_string(expr.eval()));
		Readline.History.add(line);
	}

	return 0;
}
