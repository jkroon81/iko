ikocaslib-1.0.typelib : ikocaslib-1.0.gir
	g-ir-compiler $< -o $@

lib_LTLIBRARIES = libikocaslib.la

libikocaslib_la_CFLAGS = \
	@GOBJECT_CFLAGS@ \
	-I$(top_srcdir)/ikocas

libikocaslib_la_LIBADD = \
	@GOBJECT_LIBS@ \
	$(top_builddir)/ikocas/libikocas.la

libikocaslib_la_SOURCES = \
	iko-cas-lib-integer.vala

libikocaslib_la_VALAFLAGS = \
	--gir=ikocaslib-1.0.gir \
	--header=ikocaslib.h \
	--library=ikocaslib \
	--pkg=ikocas \
	--vapidir=$(top_srcdir)/ikocas

noinst_typelib_DATA = ikocaslib-1.0.typelib

noinst_typelibdir =

CLEANFILES = *~

