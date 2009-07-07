lib_LTLIBRARIES = libgee.la

CLEANFILES = \
	gee.gir \
	gee.h \
	gee.vapi \
	*~

libgee_la_SOURCES = \
	arraylist.vala \
	collectionobject.vala \
	collection.vala \
	hashmap.vala \
	hashset.vala \
	iterable.vala \
	iterator.vala \
	list.vala \
	map.vala \
	readonlycollection.vala \
	readonlylist.vala \
	readonlymap.vala \
	readonlyset.vala \
	set.vala

libgee_la_VALAFLAGS = \
	--library=gee \
	-C -H gee.h

libgee_la_CFLAGS = \
	@GOBJECT_CFLAGS@

libgee_la_LIBADD = \
	@GOBJECT_LIBS@

