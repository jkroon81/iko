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
	if(args.length != 3) {
		stdout.printf("Usage: icc <infile> <outfile>\n");
		return 0;
	}

	Environment.set_prgname("icc");

	var parser = new Iko.CAS.Parser();
	var vala = new ValaWriter();
	try {
		parser.set_source_from_file(args[1]);
		vala.compile(parser.parse_root(), args[2]);
	} catch(Iko.CAS.Error e) {
		stdout.printf("icc: %s\n", e.message);
		return -1;
	} catch(Error e) {
		stdout.printf("icc: %s\n", e.message);
		return -1;
	}

	return 0;
}
