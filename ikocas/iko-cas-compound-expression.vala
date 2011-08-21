/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.CompoundExpression : Expression {
	Node? head;
	Node? tail;

	public int size { get; private set; }

	public CompoundExpression.from_binary(Kind kind, Expression x1, Expression x2) {
		Object(kind : kind);
		append(x1);
		append(x2);
	}

	public CompoundExpression.from_empty(Kind kind) {
		Object(kind : kind);
	}

	public CompoundExpression.from_list(Kind kind, List l) {
		Object(kind : kind);
		foreach(var t in l)
			append(t);
	}

	public CompoundExpression.from_unary(Kind kind, Expression x) {
		Object(kind : kind);
		append(x);
	}

	public static CompoundExpression from_va(Kind kind, int n, ...) {
		var s = new CompoundExpression.from_empty(kind);
		var args = va_list();
		while(n-- > 0)
			s.append(args.arg<Expression?>());
		return s;
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_compound_expression(this);
	}

	public void append(Expression e) {
		if(tail == null)
			head = tail = new Node(e, null, null);
		else
			tail = new Node(e, tail, null);
		size++;
	}

	public new Expression? get(int index) {
		assert(index >= 0 && index < size);

		var node = head;

		while(index > 0) {
			index--;
			if(node == null)
				return null;
			else
				node = node.next;
		}
		return node.expr;
	}

	public Iterator iterator() {
		return new Iterator(this);
	}

	public void prepend(Expression e) {
		if(head == null)
			head = tail = new Node(e, null, null);
		else
			head = new Node(e, null, head);
		size++;
	}

	public new void set(int index, Expression e) {
		assert(index >= 0 && index < size);

		var node = head;

		while(index > 0) {
			index--;
			node = node.next;
		}
		node.expr = e;
	}

	public List to_list() {
		var r = new List();

		foreach(var op in this)
			r.append(op);

		return r;
	}

	public class Iterator {
		CompoundExpression ce;
		Node? node;

		public Iterator(CompoundExpression ce) {
			this.ce = ce;
		}

		public new Expression? get() {
			return node.expr;
		}

		public bool next() {
			if(node == null)
				node = ce.head;
			else if(node == ce.tail)
				return false;
			else
				node = node.next;
			return node != null;
		}
	}

	class Node {
		public Expression expr;
		public Node? prev;
		public Node? next;

		public Node(Expression expr, Node? prev, Node? next) {
			this.expr = expr;
			this.prev = prev;
			this.next = next;

			if(prev != null)
				prev.next = this;
			if(next != null)
				next.prev = this;
		}
	}
}
