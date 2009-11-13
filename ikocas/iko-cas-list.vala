/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.List<G> : Object {
	public Node<G>? head { get; private set; }
	public Node<G>? tail { get; private set; }
	public int      size { get; private set; }

	public void append(G data) {
		if(tail == null)
			head = tail = new Node<G>(data, null, null);
		else
			tail = new Node<G>(data, tail, null);
		size++;
	}

	public new G? get(int index) {
		var node = head;

		while(index > 0) {
			index--;
			if(node == null)
				return null;
			else
				node = node.next;
		}
		return node.data;
	}

	public Iterator<G> iterator() {
		return new Iterator<G>(this);
	}

	public Node<G> replace_node_with_list(Node<G> node, List<G> list) {
		var mark = node.next;
		node.data = list.head.data;
		node.next = list.head.next;
		list.tail.next = mark;
		if(mark != null)
			mark.prev = list.tail;
		if(node == head)
			head = list.head;
		if(node == tail)
			tail = list.tail;
		size += list.size - 1;
		return list.tail;
	}

	public class Iterator<G> {
		List<G> list;
		Node<G>? node;

		public Iterator(List<G> list) {
			this.list = list;
		}

		public new G? get() {
			return node.data;
		}

		public bool next() {
			if(node == null)
				node = list.head;
			else if(node == list.tail)
				return false;
			else
				node = node.next;
			return node != null;
		}
	}

	public class Node<G> {
		public G        data;
		public Node<G>? prev;
		public Node<G>? next;

		public Node(G data, Node<G>? prev, Node<G>? next) {
			this.data = data;
			this.prev = prev;
			this.next = next;

			if(prev != null)
				prev.next = this;
			if(next != null)
				next.prev = this;
		}
	}
}
