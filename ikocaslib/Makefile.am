ikocaslib-1.0.typelib : ikocaslib-1.0.gir
	g-ir-compiler $< -o $@

ikocaslib-1.0.typelib.c : ikocaslib-1.0.typelib
	xxd -i $< $@

lib_LTLIBRARIES = libikocaslib.la

libikocaslib_la_CFLAGS = \
	@GOBJECT_CFLAGS@ \
	@GI_CFLAGS@ \
	-I$(top_srcdir)/ikocas \
	-I$(top_srcdir)/vapi

libikocaslib_la_LIBADD = \
	@GOBJECT_LIBS@ \
	@GI_LIBS@ \
	$(top_builddir)/ikocas/libikocas.la

libikocaslib_la_SOURCES = \
	iko-cas-lib.vala \
	iko-cas-lib-integer.vala

libikocaslib_la_VALAFLAGS = \
	--gir=ikocaslib-1.0.gir \
	--header=ikocaslib.h \
	--library=ikocaslib \
	--pkg=gi \
	--pkg=ikocas \
	--pkg=ikocaslib-1.0.typelib \
	--vapidir=$(top_srcdir)/ikocas \
	--vapidir=$(top_srcdir)/ikocaslib \
	--vapidir=$(top_srcdir)/vapi

nodist_libikocaslib_la_SOURCES = \
	ikocaslib-1.0.typelib.c

noinst_typelib_DATA = ikocaslib-1.0.typelib

noinst_typelibdir =

CLEANFILES = *~

