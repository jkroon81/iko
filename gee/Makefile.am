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
	arraylist.vala \
	collection.vala \
	functions.vala \
	hashmap.vala \
	hashset.vala \
	iterable.vala \
	iterator.vala \
	linkedlist.vala \
	list.vala \
	map.vala \
	readonlycollection.vala \
	readonlylist.vala \
	readonlymap.vala \
	readonlyset.vala \
	set.vala \
	treemap.vala \
	treeset.vala

libgee_la_VALAFLAGS = \
	--library=gee \
	-C -H gee.h

libgee_la_CFLAGS = \
	@GOBJECT_CFLAGS@

libgee_la_LIBADD = \
	@GOBJECT_LIBS@

