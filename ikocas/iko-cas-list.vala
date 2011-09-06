/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.List : Expression {
	Node? head;
	Node? tail;

	public int size { get; private set; }

	public List.from_binary(Kind kind, Expression x1, Expression x2) {
		Object(kind : kind);
		append(x1);
		append(x2);
	}

	public List.from_empty(Kind kind) {
		Object(kind : kind);
	}

	public List.from_list(Kind kind, List l) {
		Object(kind : kind);

		foreach(var e in l)
			append(e);
	}

	public List.from_unary(Kind kind, Expression x) {
		Object(kind : kind);
		append(x);
	}

	public static List from_va(Kind kind, int n, ...) {
		var l = new List.from_empty(kind);
		var args = va_list();
		while(n-- > 0)
			l.append(args.arg<Expression?>());
		return l;
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_list(this);
	}

	public void append(Expression e) {
		if(tail == null)
			head = tail = new Node(e, null, null);
		else
			tail = new Node(e, tail, null);
		size++;
	}

	public List copy() {
		var l = new List.from_empty(kind);

		foreach(var e in this)
			l.append(e);

		return l;
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

	public List rest() {
		var l = new List.from_empty(kind);

		for(var i = 1; i < size; i++)
			l.append(this[i]);

		return l;
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

	public class Iterator {
		List l;
		Node? node;

		public Iterator(List l) {
			this.l = l;
		}

		public new Expression? get() {
			return node.expr;
		}

		public bool next() {
			if(node == null)
				node = l.head;
			else if(node == l.tail)
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
