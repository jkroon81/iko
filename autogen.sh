libtoolize --automake            || exit 1
aclocal -Ibuild                  || exit 1
automake --add-missing           || exit 1
autoconf                         || exit 1
./configure $*
