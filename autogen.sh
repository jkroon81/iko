perl vala-support                || exit 1
libtoolize --automake            || exit 1
aclocal                          || exit 1
automake --foreign --add-missing || exit 1
autoconf                         || exit 1
