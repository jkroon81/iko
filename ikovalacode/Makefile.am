lib_LTLIBRARIES = libikovalacode.la

CLEANFILES =                                         \
	*~

libikovalacode_la_SOURCES =                          \
	iko-valacode-generator.vala

libikovalacode_la_VALAFLAGS =                        \
	--library=ikovalacode                        \
	--vapidir=$(top_builddir)/gee                \
	--vapidir=$(top_builddir)/iko                \
	--vapidir=$(top_builddir)/ikoast             \
	--pkg=gee                                    \
	--pkg=iko                                    \
	--pkg=ikoast                                 \
	-C -H ikovalacode.h

libikovalacode_la_CFLAGS =                           \
	@GOBJECT_CFLAGS@                             \
	-I$(top_srcdir)/gee                          \
	-I$(top_srcdir)/iko                          \
	-I$(top_srcdir)/ikoast

libikovalacode_la_LIBADD =                           \
	$(top_builddir)/gee/libgee.la                \
	$(top_builddir)/iko/libiko.la                \
	$(top_builddir)/ikoast/libikoast.la

include Makefile.vm
