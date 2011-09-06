/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.SourceReference : Object {
	public string?        src   { private get; construct; }
	public SourceLocation begin { private get; construct; }
	public SourceLocation end   { private get; construct; }

	public SourceReference(string? src, SourceLocation begin, SourceLocation end) {
		Object(src : src, begin : begin, end : end);
	}

	public string to_string(string msg) {
		var buffer = new StringBuilder();
		if(src != null)
			buffer.append("%s:%s-%s".printf(src, begin.to_string(), end.to_string()));
		else
			buffer.append("%s-%s".printf(begin.to_string(), end.to_string()));
		buffer.append(": " + msg + "\n");
		var p = begin.src;
		var line = begin.line;
		while(line <= end.line) {
			var c = p;
			while(*c != '\n' && *c != 0)
				buffer.append_c(*c++);
			buffer.append_c('\n');
			var col = 1;
			while(p < c) {
				var mark = false;
				if(begin.line == end.line) {
					if(col >= begin.column && col <= end.column)
						mark = true;
				} else if(line == begin.line) {
					if(col >= begin.column)
						mark = true;
				} else if(line == end.line) {
					if(col <= end.column)
						mark = true;
				} else
					mark = true;
				if(mark)
					buffer.append_c('^');
				else if(*p == '\t')
					buffer.append_c('\t');
				else
					buffer.append_c(' ');
				p++;
				col++;
			}
			if(line == begin.line && col <= begin.column)
				while(col++ <= begin.column)
					buffer.append_c('^');
			line++;
			c++;
			buffer.append_c('\n');
		}
		return buffer.str;
	}
}
