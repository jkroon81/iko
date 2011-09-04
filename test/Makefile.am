bin_PROGRAMS = \
	icas

check_PROGRAMS = \
	test-addition \
	test-algebraic \
	test-big-number \
	test-constant-folding \
	test-multiplication \
	test-power

icas_CFLAGS = \
	@GOBJECT_CFLAGS@ \
	-I$(top_srcdir)/ikocas \
	-I$(top_srcdir)/ikocaslib

icas_LDADD = \
	@GOBJECT_LIBS@ \
	$(top_builddir)/ikocas/libikocas.la \
	$(top_builddir)/ikocaslib/libikocaslib.la \
	-lreadline

icas_SOURCES = \
	icas.vala

icas_VALAFLAGS = \
	--pkg=ikocas \
	--pkg=ikocaslib \
	--pkg=posix \
	--pkg=readline \
	--vapidir=$(top_srcdir)/ikocas \
	--vapidir=$(top_srcdir)/ikocaslib

test_addition_SOURCES = \
	test-addition.vala \
	test-common.vala

test_algebraic_SOURCES = \
	test-algebraic.vala \
	test-common.vala

test_big_number_SOURCES = \
	test-big-number.vala \
	test-common.vala

test_constant_folding_SOURCES = \
	test-common.vala \
	test-constant-folding.vala

test_multiplication_SOURCES = \
	test-common.vala \
	test-multiplication.vala

test_power_SOURCES = \
	test-common.vala \
	test-power.vala

AM_CFLAGS = \
	@GOBJECT_CFLAGS@ \
	-I$(top_srcdir)/ikocas \
	-I$(top_srcdir)/ikocaslib

AM_VALAFLAGS = \
	--pkg=ikocas \
	--pkg=ikocaslib \
	--vapidir=$(top_srcdir)/ikocas \
	--vapidir=$(top_srcdir)/ikocaslib

CLEANFILES = *~

LDADD = \
	@GOBJECT_LIBS@ \
	$(top_builddir)/ikocas/libikocas.la \
	$(top_builddir)/ikocaslib/libikocaslib.la

TESTS = \
	test-addition \
	test-algebraic \
	test-big-number \
	test-constant-folding \
	test-multiplication \
	test-power

XFAIL_TESTS = \
	test-power

