dnl Process this file with autoconf to produce a configure script.
AC_PREREQ([2.54])
AC_INIT([pulque], [0.1])
AM_INIT_AUTOMAKE([foreign 1.9 tar-ustar])

AC_PROG_INSTALL

AC_PATH_PROG(RUBY, ruby, no)
if test "x$RUBY" = "xno"; then
        AC_MSG_ERROR([ruby Not found])
fi
AC_SUBST(RUBY)

AC_CONFIG_FILES([
Makefile
])

AC_OUTPUT

