ld-bin := icc
icc-sources := icc.vala vala-writer.vala
icc-vala-sharedlibs := $(top-builddir)/ikocas/ikocas
icc-ldflags := $(shell pkg-config gobject-introspection-1.0 --libs) -lgmp

vala-writer.o-ccflags := \
  -Wno-discarded-qualifiers \
  -Wno-incompatible-pointer-types

include $(dir $(lastword $(MAKEFILE_LIST)))../make/build.mk
