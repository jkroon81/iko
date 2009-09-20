lib_LTLIBRARIES = libgee.la

CLEANFILES = \
	gee.gir \
	gee.h \
	gee.vapi \
	*~

libgee_la_SOURCES = \
	abstractcollection.vala \
	abstractlist.vala \
	abstractmap.vala \
	abstractqueue.vala \
	abstractset.vala \
	arraylist.vala \
	bidiriterator.vala \
	collection.vala \
	comparable.vala \
	deque.vala \
	functions.vala \
	hashmap.vala \
	hashmultimap.vala \
	hashmultiset.vala \
	hashset.vala \
	iterable.vala \
	iterator.vala \
	linkedlist.vala \
	listiterator.vala \
	list.vala \
	map.vala \
	multimap.vala \
	multiset.vala \
	priorityqueue.vala \
	queue.vala \
	readonlycollection.vala \
	readonlylist.vala \
	readonlymap.vala \
	readonlyset.vala \
	set.vala \
	timsort.vala \
	treemap.vala \
	treeset.vala \
	updatablekeyiterator.vala

libgee_la_VALAFLAGS = \
	--library=gee \
	-H gee.h

libgee_la_CFLAGS = \
	@GOBJECT_CFLAGS@

libgee_la_LIBADD = \
	@GOBJECT_LIBS@

