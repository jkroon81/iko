ld-sharedlib := ikocaslib
ic-vala-sources := $(patsubst %.ic,%.vala,$(notdir $(wildcard $(srcdir)/*.ic)))
ikocaslib-ccflags := \
	$(shell pkg-config gobject-introspection-1.0 --cflags) \
	-I$(top-srcdir)/ikocaslib \
	-I$(top-srcdir)/vapi
ikocaslib-ldflags := $(shell pkg-config gobject-introspection-1.0 --libs)
ikocaslib-sources := \
	$(ic-vala-sources) \
	iko-cas-lib.vala \
	iko-cas-lib-basic-algebraic-expression.vala \
	iko-cas-lib-boolean.vala \
	iko-cas-lib-integer.vala \
	iko-cas-lib-rational-number-expression.vala \
	iko-cas-lib-set.vala
ikocaslib-vala-sharedlibs := $(top-builddir)/ikocas/ikocas
ikocaslib-valaflags := \
	--pkg=gi \
	--pkg=ikocaslib-1.0.typelib \
	--vapidir=$(top-srcdir)/ikocaslib \
	--vapidir=$(top-srcdir)/vapi
ikocaslib-girversion := 1.0
cleanfiles := $(ic-vala-sources)

ICC := $(top-builddir)/icc/icc

$(eval $(call add-vcmd,ICC))

vpath %.ic $(top-srcdir)

$(addprefix $(builddir)/,$(ic-vala-sources)) : $(ICC)

%.vala : %.ic
	$(ICC_v) $< $@

include $(dir $(lastword $(MAKEFILE_LIST)))../make/build.mk
