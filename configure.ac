AC_INIT(autogen.sh)
AC_CONFIG_AUX_DIR(build)
AM_INIT_AUTOMAKE(iko, 0.0.0)

AC_PROG_LIBTOOL()

AC_PATH_PROG(VALAC, valac, valac)

PKG_CHECK_MODULES(GOBJECT, gobject-2.0)

m4_ifdef([AM_SILENT_RULES],[AM_SILENT_RULES([yes])])

AC_OUTPUT(
	Makefile
	examples/Makefile
	gee/Makefile
	iko/Makefile
	ikoast/Makefile
	ikoc/Makefile
	ikovalacode/Makefile
	test/Makefile
	util/Makefile
	)
