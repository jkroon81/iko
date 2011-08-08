/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.CAS.CompoundExpression : Expression {
	Node? head;
	Node? tail;

	public int size { get; private set; }

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_compound_expression(this);
	}

	public override void accept_children(Visitor v) {
		base.accept_children(v);
		foreach(var e in this)
			e.accept(v);
	}

	public void append(Expression e) {
		if(tail == null)
			head = tail = new Node(e, null, null);
		else
			tail = new Node(e, tail, null);
		size++;
	}

	public override Expression eval() {
		return this;
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
