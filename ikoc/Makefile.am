bin_PROGRAMS = ikoc

CLEANFILES =                                         \
	*~

ikoc_SOURCES =                                       \
	ikoc.vala

ikoc_VALAFLAGS =                                     \
	--vapidir=$(top_builddir)/gee                \
	--vapidir=$(top_builddir)/iko                \
	--pkg=gee                                    \
	--pkg=iko                                    \
	-C

ikoc_CFLAGS =                                        \
	@GOBJECT_CFLAGS@                             \
	-I$(top_srcdir)/gee                          \
	-I$(top_srcdir)/iko

ikoc_LDADD =                                         \
	$(top_builddir)/gee/libgee.la                \
	$(top_builddir)/iko/libiko.la

include Makefile.vm
