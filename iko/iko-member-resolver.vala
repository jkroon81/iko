/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.MemberResolver : Visitor {
	Symbol? current_symbol;

	public override void visit_member_access(MemberAccess m) {
		Member member = null;

		if(m.member is UnresolvedMember) {
			if(m.inner != null) {
				m.inner.accept(this);
				member = m.inner.data_type.scope.lookup(m.member.name) as Member;
			} else {
				Symbol s = current_symbol;

				while(s != null) {
					var sym = s.scope.lookup(m.member.name);
					if(sym is Member) {
						member = sym as Member;
						break;
					}
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
}
