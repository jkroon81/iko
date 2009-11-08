/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.TypeResolver : Visitor {
	Symbol? current_symbol;

	public override void visit_node(Node n) {
		if(n is Symbol)
			current_symbol = n as Symbol;
		n.accept_children(this);
		if(n is Symbol)
			current_symbol = (n as Symbol).parent;
	}

	public override void visit_type_access(TypeAccess t) {
		TypeSymbol type_symbol = null;

		if(t.type_symbol is UnresolvedType) {
			if(t.inner != null) {
				t.inner.accept(this);
				type_symbol = t.inner.scope.lookup(t.type_symbol.name) as TypeSymbol;
			} else {
				Symbol s = current_symbol;

				while(s != null) {
					var sym = s.scope.lookup(t.type_symbol.name);
					if(sym is TypeSymbol) {
						type_symbol = sym as TypeSymbol;
						break;
					}
					s = s.parent;
				}
			}
			if(type_symbol == null)
				Report.error("%s:unresolved type '%s'".printf(t.type_symbol.src.to_string(), t.type_symbol.name));
			else
				t.type_symbol = type_symbol;
		}
	}
}
