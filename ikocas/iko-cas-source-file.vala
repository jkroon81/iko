/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.SourceFile : Node {
	public SList<Function> function;

	public string filename { get; construct; }

	public SourceFile(string filename) {
		Object(filename : filename);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_source_file(this);
	}
}
