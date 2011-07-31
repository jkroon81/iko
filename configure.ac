AC_INIT(autogen.sh)
AC_CONFIG_AUX_DIR(build)
AM_INIT_AUTOMAKE(iko, 0.0.0)

AC_PROG_LIBTOOL()

AM_PROG_CC_C_O()

AM_PROG_VALAC()

PKG_CHECK_MODULES(GOBJECT, gobject-2.0)
PKG_CHECK_MODULES(GI, gobject-introspection-1.0)

m4_ifdef([AM_SILENT_RULES],[AM_SILENT_RULES([yes])])

AC_OUTPUT(
	Makefile
	examples/Makefile
	iko/Makefile
	ikoast/Makefile
	ikoc/Makefile
	ikocas/Makefile
	ikocaslib/Makefile
	ikovalacode/Makefile
	test/Makefile
	util/Makefile
	)
