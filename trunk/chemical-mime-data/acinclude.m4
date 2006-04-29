dnl Document  $Id$
dnl Summary   Custom macros for the configure script.
dnl
dnl Copyright (C) 2006 by Daniel Leidert.
dnl
dnl Copying and distribution of this file, with or without modification,
dnl are permitted in any medium without royalty provided the copyright
dnl notice and this notice are preserved.


dnl @synopsis MP_PROG_XSLTPROC
dnl
dnl @summary Determine if we can use the xsltproc program
dnl
dnl This is a simple macro to define the location of xsltproc (which can
dnl be overridden by the user) and special options to use.
dnl
dnl @category InstalledPackages
dnl @author Daniel Leidert <daniel.leidert@wgdd.de>
dnl @version 2006-03-10
dnl @license AllPermissive
AC_DEFUN([MP_PROG_XSLTPROC],[
AC_ARG_VAR(
	[XSLTPROC],
	[The 'xsltproc' binary with path. Use it to define or override the location of 'xsltproc'.]
)
AC_PATH_PROG([XSLTPROC], [xsltproc])
if test -z $XSLTPROC ; then
	AC_MSG_ERROR(['xsltproc' was not found! We cannot proceed. See README.]) ;
fi
AC_SUBST([XSLTPROC])

AC_ARG_VAR(
	[XSLTPROC_FLAGS],
	[More options, which should be used along with 'xsltproc', like e.g. '--nonet'.]
)
AC_SUBST([XSLTPROC_FLAGS])
echo -n "checking for optional xsltproc options to use... "
echo $XSLTPROC_FLAGS
]) # MP_PROG_XSLTPROC