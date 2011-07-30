/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.SymbolResolver : Visitor {
	Symbol? current_symbol;

	public override void visit_member_access(MemberAccess m) {
		Member member = null;

		if(m.member is UnresolvedMember) {
			if(m.inner != null) {
				m.inner.accept(this);
				m.inner.data_type.accept(this);
				member = m.inner.data_type.scope.lookup(m.member.name) as Member;
			} else {
				Symbol s = current_symbol;

				while(s != null) {
					member = s.scope.lookup(m.member.name) as Member;
					if(member != null)
						break;
					else
						s = s.parent;
				}
			}
			if(member == null)
				Report.error("%s:unresolved member '%s'".printf(m.member.src.to_string(), m.member.name));
			else
				m.member = member;
		}
	}

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
					type_symbol = s.scope.lookup(t.type_symbol.name) as TypeSymbol;
					if(type_symbol != null)
						break;
					else
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
