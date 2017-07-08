all-vala-sharedlibs := \
  $(top-builddir)/ikocas/ikocas \
  $(top-builddir)/ikocaslib/ikocaslib
ldflags := $(shell pkg-config gobject-introspection-1.0 --libs) -lgmp -rdynamic

ld-bin := \
	icas \
	test-addition \
	test-algebraic \
	test-big-number \
	test-constant-folding \
	test-multiplication \
	test-power
$(foreach b,$(ld-bin),$(eval $b-vala-staticlibs := $(builddir)/test-common))
$(foreach b,$(ld-bin),$(eval $b-vala-sharedlibs := $(all-vala-sharedlibs)))
ld-staticlib := test-common
test-common-sources := test-common.vala
test-common-vala-sharedlibs := $(all-vala-sharedlibs)
icas-sources := icas.vala
icas-valaflags := --pkg=posix --pkg=readline
icas-ldflags := -lreadline
test-addition-sources := test-addition.vala
test-algebraic-sources := test-algebraic.vala
test-big-number-sources := test-big-number.vala
test-constant-folding-sources := test-constant-folding.vala
test-multiplication-sources := test-multiplication.vala
test-power-sources := test-power.vala

include $(dir $(lastword $(MAKEFILE_LIST)))../make/build.mk
