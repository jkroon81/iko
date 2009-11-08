/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.Symbol : Node {
	public string  name   { get; construct; default = "(null)"; }
	public Symbol? parent { get; set; }
	public Scope   scope  { get; private set; }

	construct {
		scope = new Scope(this);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_symbol(this);
	}

	public string get_full_name() {
		if(parent != null)
			return parent.get_full_name() + "." + name;
		else
			return name;
	}
}
