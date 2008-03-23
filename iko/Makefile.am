lib_LTLIBRARIES = libiko.la

CLEANFILES =                                         \
	iko.gidl                                     \
	iko.vapi                                     \
	*~

libiko_la_SOURCES =                                  \
	iko-klass.vala

libiko_la_VALAFLAGS =                                \
	--vapidir=/opt/vala-svn/share/vala/vapi      \
	--library=iko

libiko_la_CFLAGS =                                   \
	@GOBJECT_CFLAGS@                             \
	-I$(top_builddir)

libiko_la_LIBADD =                                   \
	@GOBJECT_LIBS@

include Makefile.vm
