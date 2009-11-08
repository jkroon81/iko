/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.SourceReference : Object {
	public string         filename { private get; construct; }
	public SourceLocation begin    { private get; construct; }
	public SourceLocation end      { private get; construct; }

	public SourceReference(string filename, SourceLocation begin, SourceLocation end) {
		this.filename = filename;
		this.begin    = begin;
		this.end      = end;
	}

	public string to_string() {
		return "%s:%s-%s".printf(filename, begin.to_string(), end.to_string());
	}
}
