/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

int main(string[] args) {
	Environment.set_prgname("icas");

	var parser = new Iko.CAS.Parser();

	while(true) {
		stdout.printf("> ");
		var line = stdin.read_line();
		if(line == null)
			break;
		switch(line) {
		default:
			var expr = parser.parse_source_string(line);
			stdout.printf("%s\n", new Iko.CAS.Writer().generate_string(expr));
			break;
		}
	}
	stdout.printf("\n");

	return 0;
}
