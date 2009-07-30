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
      var id = (t.type_symbol as UnresolvedType).id;
      if(t.inner != null) {
        t.inner.accept(this);
        var sym = t.inner.scope.lookup(id);
        if(sym is TypeSymbol)
          type_symbol = sym as TypeSymbol;
      } else {
        Symbol s = current_symbol;

        while(s != null) {
          var sym = s.scope.lookup(id);
          if(sym is TypeSymbol) {
            type_symbol = sym as TypeSymbol;
            break;
          }
          s = s.parent;
        }
      }
      if(type_symbol == null)
        Report.error(t.type_symbol.src, "unresolved type '%s'".printf(id));
      else
        t.type_symbol = type_symbol;
    }
  }
}
