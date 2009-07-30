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
      var id = (m.member as UnresolvedMember).id;
      if(m.inner != null) {
        m.inner.accept(this);
        var sym = m.inner.data_type.scope.lookup(id);
        if(sym is Member)
          member = sym as Member;
      } else {
        Symbol s = current_symbol;

        while(s != null) {
          var sym = s.scope.lookup(id);
          if(sym is Member) {
            member = sym as Member;
            break;
          }
          s = s.parent;
        }
      }
      if(member == null)
        Report.error(m.member.src, "unresolved member '%s'".printf(id));
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
