dnl Document  $Id$
dnl Summary   Configure script for the chemical-mime-data project.
dnl
dnl Copyright (C) 2004-2006 by Egon Willighagen and Daniel Leidert.
dnl All rights reserved.
dnl
dnl This file is free software. The copyright owner gives unlimited
dnl permission to copy, distribute and modify it.
dnl
dnl --------------------------------------------------------------------------
dnl initialization
dnl --------------------------------------------------------------------------

AC_INIT([chemical-mime-data],[0.1.93],[http://sourceforge.net/projects/chemical-mime/])
AM_INIT_AUTOMAKE(AC_PACKAGE_NAME, AC_PACKAGE_VERSION)
AC_REVISION($Revision$)

dnl --------------------------------------------------------------------------
dnl intltool/gettext
dnl --------------------------------------------------------------------------

ALL_LINGUAS="de"
GETTEXT_PACKAGE=AC_PACKAGE_NAME
AC_SUBST([GETTEXT_PACKAGE])
AM_GNU_GETTEXT(external)
USE_NLS=no
AC_SUBST([USE_NLS])
IT_PROG_INTLTOOL

dnl --------------------------------------------------------------------------
dnl necessary applications
dnl --------------------------------------------------------------------------

AC_PROG_INSTALL
PKG_PROG_PKG_CONFIG
MP_PROG_XMLLINT
MP_PROG_XSLTPROC

dnl --------------------------------------------------------------------------
dnl configure options
dnl --------------------------------------------------------------------------

dnl Choose to run update-mime-database
AC_ARG_ENABLE(
	[update-database],
	AC_HELP_STRING(
		[--disable-update-database],
		[Don't run the update-mime-database utility after installation.]
	),
	[ENABLE_UPDATEDB=$enableval],
	[ENABLE_UPDATEDB=yes]
)

dnl Choose to run rsvg or convert if both are installed
AC_ARG_ENABLE(
	[convert],
	AC_HELP_STRING(
		[--enable-convert],
		[Enable the usage of convert (imagemagick) if both rsvg and convert are available.]
	),
	[ENABLE_CONVERT=$enableval],
	[ENABLE_CONVERT=no]
)

dnl --------------------------------------------------------------------------
dnl rsvg or convert (imagemagick)
dnl --------------------------------------------------------------------------

AC_ARG_VAR(
	[CONVERT],
	[The convert binary with path. Use it to define or override the location of convert.]
)
AC_PATH_PROG([CONVERT], [convert])
AC_SUBST([CONVERT])

if test "x$ENABLE_CONVERT" != "xyes" -a "x$CONVERT" = "x" ; then
AC_ARG_VAR(
	[RSVG],
	[The rsvg binary with path. Use it to define or override the location of rsvg.]
)
AC_PATH_PROG([RSVG], [rsvg])
AC_SUBST([RSVG])
fi

if test "x$RSVG" = "x" -a "x$CONVERT" = "x" ; then
	AC_MSG_ERROR([Cannot find rsvg (librsvg binary) or convert (imagemagick). Please install one of them.])
fi

dnl --------------------------------------------------------------------------
dnl install locations
dnl --------------------------------------------------------------------------

AC_ARG_WITH(
	[freedesktop_org-mime],
	AC_HELP_STRING(
		[--with-freedesktop_org-mime=DIR],
		[If the freedesktop.org shared MIME info support files should not be installed, use
		 --without-freedesktop_org-mime. (default DIR=$datadir/mime)]
	),
	[DIR_FDMIME=$withval],
	[DIR_FDMIME=${datadir}/mime]
)
AC_CACHE_CHECK(
	[for freedesktop.org shared MIME info support path],
	[DIR_FDMIME],
	[DIR_FDMIME=${datadir}/mime]
)
AC_SUBST([DIR_FDMIME])

AC_ARG_WITH(
	[gnome2_4-mime],
	AC_HELP_STRING(
		[--with-gnome2_4-mime=DIR],
		[If the old GNOME 2.4 MIME support files should not be installed, use
		 --without-gnome2_4-mime. (default DIR=$datadir/mime-info)]
	),
	[DIR_GNOMEMIME=$withval],
	[DIR_GNOMEMIME=${datadir}/mime-info]
)
AC_CACHE_CHECK(
	[for gnome-mime-data mime-info path],
	[DIR_GNOMEMIME],
	[DIR_GNOMEMIME=${datadir}/mime-info]
)
AC_SUBST([DIR_GNOMEMIME])

AC_ARG_WITH(
	[pixmaps],
	AC_HELP_STRING(
		[--with-pixmaps=DIR],
		[GNOME <=2.4 accepts non-themed icons for MIME support.
		Newer GNOME expect to find themed icons (also for old GNOME 2.4 MIME support). Then
		you should use --without-pixmaps. (default DIR=$datadir/pixmaps)]
	),
	[DIR_PIXMAPS=$withval],
	[DIR_PIXMAPS=${datadir}/pixmaps]
)
AC_CACHE_CHECK(
	[for pixmaps path],
	[DIR_PIXMAPS],
	[DIR_PIXMAPS=${datadir}/pixmaps]
)
AC_SUBST([DIR_PIXMAPS])

AC_ARG_WITH(
	[gnome-theme],
	AC_HELP_STRING(
		[--with-gnome-theme=DIR],
		[It's strongly recommended to install theme-icons for GNOME into the hicolor-theme.
		 (default DIR=$datadir/icons/hicolor)]
	),
	[DIR_GNOMETHEME=$withval],
	[DIR_GNOMETHEME=${datadir}/icons/hicolor]
)
AC_CACHE_CHECK(
	[for gnome-theme path],
	[DIR_GNOMETHEME],
	[DIR_GNOMETHEME=${datadir}/icons/hicolor]
)
AC_SUBST([DIR_GNOMETHEME])

AC_ARG_WITH(
	[kde-mime],
	AC_HELP_STRING(
		[--with-kde-mime=DIR],
		[If the KDE 3.x MIME support files should not be installed, use
		 --without-kde-mime. (default DIR=$datadir/mimelnk)]
	),
	[DIR_KDEMIME=$withval],
	[DIR_KDEMIME=${datadir}/mimelnk]
)
AC_CACHE_CHECK(
	[for KDE mimelnk path],
	[DIR_KDEMIME],
	[DIR_KDEMIME=${datadir}/mimelnk]
)
AC_SUBST([DIR_KDEMIME])

AC_ARG_WITH(
	[kde-theme],
	AC_HELP_STRING(
		[--with-kde-theme=DIR],
		[Default theme for KDE is crystalsvg.
		 (default DIR=$datadir/icons/crystalsvg)]
	),
	[DIR_KDETHEME=$withval],
	[DIR_KDETHEME=${datadir}/icons/crystalsvg]
)
AC_CACHE_CHECK(
	[for KDE theme path],
	[DIR_KDETHEME],
	[DIR_KDETHEME=${datadir}/icons/crystalsvg]
)
AC_SUBST([DIR_KDETHEME])

dnl --------------------------------------------------------------------------
dnl necessary checks
dnl --------------------------------------------------------------------------

dnl necessary checks and additions for freedesktop.org shared-mime-info
if test "$DIR_FDMIME" != "no" ; then
	echo -n "checking for shared-mime-info >= 0.12... "
	PKG_CHECK_EXISTS(
		[shared-mime-info >= 0.12],
		[echo "yes" ;	CHEMICAL_MIME_DEPS="shared-mime-info $CHEMICAL_MIME_DEPS"],
		[echo "no"  ; AC_MSG_ERROR([shared-mime-info package missing.])]
	)
	AC_ARG_VAR(
		[UPDATE_MIME_DATABASE],
		[The update-mime-database binary with path.
		 Use it to define or override the location of update-mime-database.]
	)
	AC_PATH_PROG([UPDATE_MIME_DATABASE], [update-mime-database])
	AC_SUBST([UPDATE_MIME_DATABASE])
fi

dnl necessary checks and additions for old gnome 2.4 mime support
if test "$DIR_GNOMEMIME" != "no" ; then
	echo -n "checking for gnome-mime-data... "
	PKG_CHECK_EXISTS(
		[gnome-mime-data-2.0],
		[echo "yes" ; CHEMICAL_MIME_DEPS="gnome-mime-data-2.0 $CHEMICAL_MIME_DEPS"],
		[echo "no"  ; AC_MSG_ERROR([gnome-mime-data package missing.])]
	)
fi
AC_SUBST([CHEMICAL_MIME_DEPS])

dnl --------------------------------------------------------------------------
dnl conditions
dnl --------------------------------------------------------------------------

AM_CONDITIONAL(BOOL_FREEDESKTOP_MIME, [test "$DIR_FDMIME" != "no"])
echo -n "checking for freedesktop.org shared MIME-info database file will be installed ... "
if test "$DIR_FDMIME" != "no" ; then
	echo "yes"
else
	echo "no"
fi

AM_CONDITIONAL(BOOL_UPDATE_DATABASE, [test "x$ENABLE_UPDATEDB" = "xyes" -a "x$UPDATE_MIME_DATABASE" != "x" -a "$DIR_FDMIME" != "no"])
echo -n "checking for update-mime-database will run ... "
if test "x$ENABLE_UPDATEDB" = "xyes" -a "x$UPDATE_MIME_DATABASE" != "x" ; then
	echo "yes"
elif test "x$ENABLE_UPDATEDB" = "xyes" -a "x$UPDATE_MIME_DATABASE" = "x" ; then
	echo "no (couldn't be found)"
elif test "x$ENABLE_UPDATEDB" = "xno" ; then
	echo "no (disabled)"
fi

echo -n "checking for old GNOME 2.4 support files will be installed ... "
if test "$DIR_PIXMAPS" = "no"; then
	AM_CONDITIONAL(BOOL_GNOME_MIME, [test "$DIR_GNOMEMIME" != "no" -a "$DIR_GNOMETHEME" != "no"])
	if test "$DIR_GNOMEMIME" != "no" -a "$DIR_GNOMETHEME" != "no" ; then
		echo "yes (with theme icons)"
	elif test "$DIR_GNOMEMIME" != "no" -a "$DIR_GNOMETHEME" = "no" ; then
		echo "no (icons disabled in general)"
	else
		echo "no"
	fi
	AM_CONDITIONAL(BOOL_GNOME_THEME, [test "$DIR_FDMIME" != "no" -o "$DIR_GNOMEMIME" != "no"])
else
	AM_CONDITIONAL(BOOL_GNOME_MIME, [test "$DIR_GNOMEMIME" != "no"])
	if test "$DIR_GNOMEMIME" != "no" ; then
		echo "yes (without theme icons)"
	else
		echo "no"
	fi
	AM_CONDITIONAL(BOOL_GNOME_THEME, [test "$DIR_FDMIME" != "no"])
fi
AM_CONDITIONAL(BOOL_GNOME_ICONS, [test "$DIR_GNOMEMIME" != "no" -a "$DIR_PIXMAPS" != "no"])

AM_CONDITIONAL(BOOL_KDE_MIME, [test "$DIR_KDEMIME" != "no" -a "$DIR_KDETHEME" != "no"])
echo -n "checking for KDE support files will be installed ... "
if test "$DIR_KDEMIME" != "no" -a "$DIR_KDETHEME" != "no" ; then
	echo "yes"
elif test "$DIR_KDEMIME" != "no" -a "$DIR_KDETHEME" = "no" ; then
	echo "no (icon installation disabled)"
else
	echo "no"
fi

dnl --------------------------------------------------------------------------
dnl output
dnl --------------------------------------------------------------------------

AC_CONFIG_FILES([
	chemical-mime-data.pc
	Makefile
	freedesktop.org/Makefile
	icons/Makefile
	icons/crystalsvg/Makefile
	icons/hicolor/Makefile
	icons/pixmaps/Makefile
	kde/Makefile
	gnome/Makefile
	po/Makefile.in
	src/Makefile
	xsl/Makefile
])
AC_OUTPUT
