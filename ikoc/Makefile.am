bin_PROGRAMS = ikoc

CLEANFILES =                                         \
	*~

ikoc_SOURCES =                                       \
	ikoc.vala

ikoc_VALAFLAGS =                                     \
	--vapidir=$(top_builddir)/gee                \
	--vapidir=$(top_builddir)/iko                \
	--vapidir=$(top_builddir)/ikoast             \
	--pkg=gee                                    \
	--pkg=iko                                    \
	--pkg=ikoast                                 \
	-C

ikoc_CFLAGS =                                        \
	@GOBJECT_CFLAGS@                             \
	-I$(top_srcdir)/gee                          \
	-I$(top_srcdir)/iko                          \
	-I$(top_srcdir)/ikoast

ikoc_LDADD =                                         \
	$(top_builddir)/gee/libgee.la                \
	$(top_builddir)/iko/libiko.la                \
	$(top_builddir)/ikoast/libikoast.la

include Makefile.vm
