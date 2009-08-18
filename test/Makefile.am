bin_PROGRAMS = \
	transformer

check_PROGRAMS = \
	test-algebra \
	test-power \
	test-simplify

CLEANFILES = \
	*~

TESTS = \
	test-algebra \
	test-power \
	test-simplify

test_algebra_SOURCES = test-common.vala test-algebra.vala
test_power_SOURCES = test-common.vala test-power.vala
test_simplify_SOURCES = test-common.vala test-simplify.vala
transformer_SOURCES = transformer.vala

VALAFLAGS = \
	--vapidir=$(top_builddir)/gee \
	--vapidir=$(top_builddir)/iko \
	--vapidir=$(top_builddir)/ikoast \
	--pkg=gee \
	--pkg=iko \
	--pkg=ikoast \
	-C

CFLAGS = \
	@GOBJECT_CFLAGS@ \
	-I$(top_srcdir)/gee \
	-I$(top_srcdir)/iko \
	-I$(top_srcdir)/ikoast

LDADD = \
	$(top_builddir)/gee/libgee.la \
	$(top_builddir)/iko/libiko.la \
	$(top_builddir)/ikoast/libikoast.la
