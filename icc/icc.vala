/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public errordomain Error {
	IO
}

int main(string[] args) {
	int i;

	if(args.length == 1) {
		stdout.printf("Usage: icc infile...\n");
		return 0;
	}

	Environment.set_prgname("icc");

	var parser = new Iko.CAS.Parser();
	var vala = new ValaWriter();
	for(i = 1; i < args.length; i++) {
		try {
			parser.set_source_from_file(args[i]);
			vala.compile(parser.parse_root(), args[i].replace(".ic", ".vala"));
		} catch(Iko.CAS.Error e) {
			stdout.printf("icc: %s\n", e.message);
			return -1;
		} catch(Error e) {
			stdout.printf("icc: %s\n", e.message);
			return -1;
		}
	}

	return 0;
}
