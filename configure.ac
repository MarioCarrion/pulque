dnl Process this file with autoconf to produce a configure script.
AC_PREREQ([2.54])
AC_INIT([pulque], [0.1])
AM_INIT_AUTOMAKE([foreign 1.9 tar-ustar])

AC_PROG_INSTALL

AC_PATH_PROG(SETUPRB, setup.rb, no)
if test "x$SETUPRB" = "xno"; then
        AC_MSG_ERROR([setup.rb Not found])
fi
AC_SUBST(SETUPRB)

AC_CONFIG_FILES([
Makefile
])

AC_OUTPUT

