/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.MemberResolver : Visitor {
  Symbol? current_symbol;

  public override void visit_block(Block b) {
    b.accept_children(this);
  }

  public override void visit_context(Context c) {
    c.accept_children(this);
  }

  public override void visit_equation(Equation e) {
    e.accept_children(this);
  }

  public override void visit_expression(Expression e) {
    e.accept_children(this);
  }

  public override void visit_field(Field f) {
    f.accept_children(this);
  }

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

  public override void visit_model(Model m) {
    m.accept_children(this);
  }

  public override void visit_symbol(Symbol s) {
    current_symbol = s;
    s.accept_children(this);
    current_symbol = s.parent;
  }
}
