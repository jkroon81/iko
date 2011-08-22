noinst_PROGRAMS = icc

icc_CFLAGS = \
	@GOBJECT_CFLAGS@ \
	-I$(top_srcdir)/ikocas

icc_LDADD = \
	@GOBJECT_LIBS@ \
	$(top_builddir)/ikocas/libikocas.la

icc_SOURCES = \
	icc.vala \
	vala-writer.vala

icc_VALAFLAGS = \
	--pkg=ikocas \
	--vapidir=$(top_srcdir)/ikocas

CLEANFILES = *~

