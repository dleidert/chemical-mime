dnl --------------------------------------------------------------------------
dnl initialisation
dnl --------------------------------------------------------------------------

AC_INIT([chemical-mime-data],[0.1.0],[http://sourceforge.net/projects/cdk/])
AM_INIT_AUTOMAKE(AC_PACKAGE_NAME, AC_PACKAGE_VERSION)
AC_REVISION($Revision$)

dnl --------------------------------------------------------------------------
dnl intltool/gettext
dnl --------------------------------------------------------------------------

AC_PROG_INTLTOOL
ALL_LINGUAS="de fr nl"
AC_SUBST([ALL_LINGUAS])
AM_GLIB_GNU_GETTEXT
GETTEXT_PACKAGE=AC_PACKAGE_NAME
AC_SUBST([GETTEXT_PACKAGE])
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE, "$GETTEXT_PACKAGE",[Package name for internationalization])

dnl --------------------------------------------------------------------------
dnl necessary applications
dnl --------------------------------------------------------------------------

AC_PROG_INSTALL
PKG_PROG_PKG_CONFIG
AC_ARG_VAR(
	[RSVG],
	[The rsvg binary with path. Use it to define or override the location of rsvg.]
)
AC_PATH_PROG(RSVG, rsvg, "no")
AC_SUBST([RSVG])
AC_ARG_VAR(
	[CONVERT],
	[The convert binary with path. Use it to define or override the location of convert.]
)
AC_PATH_PROG(CONVERT, convert, "no")
AC_SUBST([CONVERT])
if test "x$RSVG" = "xno" -a "x$CONVERT" = "xno" ; then
	AC_MSG_ERROR([Cannot find rsvg (librsvg binary) or convert (imagemagick). Please install one of them.])
fi

dnl --------------------------------------------------------------------------
dnl environment settings
dnl --------------------------------------------------------------------------

case $srcdir in
        /*)
                AC_DEFINE_UNQUOTED(SRCDIR, "$srcdir",[Where chemical MIME data is compiled])
        ;;
        *)
                AC_DEFINE_UNQUOTED(SRCDIR, "`pwd`/$srcdir",[Where chemical MIME data is compiled])
        ;;
esac
if test "$prefix" = "NONE" ; then
        prefix=/usr/local
fi
AC_DEFINE_UNQUOTED(PREFIX, "$prefix",[Where chemical MIME data is to be installed])
eval dt=`echo $datadir`
AC_DEFINE_UNQUOTED(DATADIR, "$dt",[Where chemical MIME data are to be installed (default=${prefix}/share)])

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

if test "x$ENABLE_CONVERT" = "xyes" -a "x$CONVERT" != "xno" ; then
	RSVG = no
fi

dnl --------------------------------------------------------------------------
dnl install locations
dnl --------------------------------------------------------------------------

AC_ARG_WITH(
	[freedesktop_org-mime],
	AC_HELP_STRING(
		[--without-freedesktop_org-mime],
		[Don't install freedesktop.org shared MIME info support files. Use --with-freedesktop_org-mime=/path to override the default $datadir/mime.]
	),
	[DIR_FDMIME=$withval],
	[DIR_FDMIME=${datadir}/mime]
)
AC_SUBST([DIR_FDMIME])

AC_ARG_WITH(
	[gnome2_4-mime],
	AC_HELP_STRING(
		[--without-gnome2_4-mime],
		[Don't install old GNOME 2.4 MIME support files.
		 Use --with-gnome2_4-mime=/path to override the default install path $datadir/mime-info.]
	),
	[DIR_GNOMEMIME=$withval],
	[DIR_GNOMEMIME=${datadir}/mime-info]
)
AC_SUBST([DIR_GNOMEMIME])

AC_ARG_WITH(
	[pixmaps],
	AC_HELP_STRING(
		[--with-pixmaps],
		[GNOME <=2.4 accepts non-themed icons for MIME support.
		 Use --with-pixmaps=/path to override the default install path $datadir/pixmaps.
		 Newer GNOME expect to find themed icons (also for old GNOME 2.4 MIME support). Then
		 you should use --without-pixmaps.]
	),
	[DIR_PIXMAPS=$withval],
	[DIR_PIXMAPS=${datadir}/pixmaps]
)
AC_SUBST([DIR_PIXMAPS])

AC_ARG_WITH(
	[gnome-theme],
	AC_HELP_STRING(
		[--with-gnome-theme],
		[It's strongly recommended to install theme-icons for GNOME into the hicolor-theme.
		 Use --with-gnome-theme=/path if you need to override the default install path $datadir/icons/hicolor.]
	),
	[DIR_GNOMETHEME=$withval],
	[DIR_GNOMETHEME=${datadir}/icons/hicolor]
)
AC_SUBST([DIR_GNOMETHEME])

AC_ARG_WITH(
	[kde-mime],
	AC_HELP_STRING(
		[--without-kde-mime],
		[Don't install KDE 3.x MIME support files.
		 Use --with-kde-mime=/path to override the default install path $datadir/mimelnk.]
	),
	[DIR_KDEMIME=$withval],
	[DIR_KDEMIME=${datadir}/mimelnk]
)
AC_SUBST([DIR_KDEMIME])

AC_ARG_WITH(
	[kde-theme],
	AC_HELP_STRING(
		[--with-kde-theme],
		[Default theme for KDE is crystalsvg.
		 Use --with-kde-theme=/path to override the default install path $datadir/icons/crystalsvg.]
	),
	[DIR_KDETHEME=$withval],
	[DIR_KDETHEME=${datadir}/icons/crystalsvg]
)
AC_SUBST([DIR_KDETHEME])

dnl --------------------------------------------------------------------------
dnl necessary checks
dnl --------------------------------------------------------------------------

dnl necessary checks and additions for freedesktop.org shared-mime-info
if test "$DIR_FDMIME" != "no" ; then
	echo -n "checking for shared-mime-info >= 0.12 ... "
	PKG_CHECK_EXISTS(	
		shared-mime-info >= 0.12, 	[
			echo "yes"
			CHEMICAL_MIME_DEPS="shared-mime-info $CHEMICAL_MIME_DEPS"
		], [
			echo "no"
			AC_MSG_ERROR([shared-mime-info package missing.])
		]
	)
	AC_PATH_PROG(UPDATE_MIME_DATABASE, update-mime-database, "no")
	AC_SUBST([UPDATE_MIME_DATABASE])
fi

dnl necessary checks and additions for old gnome 2.4 mime support
if test "$DIR_GNOMEMIME" != "no" ; then
	echo -n "checking for gnome-mime-data ... "
	PKG_CHECK_EXISTS(	
		gnome-mime-data-2.0, [
			echo "yes"
			CHEMICAL_MIME_DEPS="gnome-mime-data-2.0 $CHEMICAL_MIME_DEPS"
		], [
			echo "no"
			AC_MSG_ERROR([gnome-mime-data package missing.])
		]
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
	echo -n "checking for shared-mime-info path ... "
	echo $DIR_FDMIME
	echo -n "checking for gnome-theme path ... "
	echo $DIR_GNOMETHEME
else
	echo "no"
fi

AM_CONDITIONAL(BOOL_UPDATE_DATABASE, [test "x$ENABLE_UPDATEDB" = "xyes" -a "$UPDATE_MIME_DATABASE" != "no" -a "$DIR_FDMIME" != "no"])
echo -n "checking for update-mime-database will run ... "
if test "x$ENABLE_UPDATEDB" = "xyes" -a "$UPDATE_MIME_DATABASE" != "no" ; then
	echo "yes"
	echo -n "checking for gnome-theme path ... "
	echo $DIR_GNOMETHEME
elif test "x$ENABLE_UPDATEDB" = "xyes" -a "$UPDATE_MIME_DATABASE" = "no" ; then
	echo "no (couldn't be found)"
elif test "x$ENABLE_UPDATEDB" = "xno" ; then
	echo "no (disabled)"
fi

echo -n "checking for old GNOME 2.4 support files will be installed ... "
if test "$DIR_PIXMAPS" = "no"; then
	AM_CONDITIONAL(BOOL_GNOME_MIME, [test "$DIR_GNOMEMIME" != "no" -a "$DIR_GNOMETHEME" != "no"])
	if test "$DIR_GNOMEMIME" != "no" -a "$DIR_GNOMETHEME" != "no" ; then
		echo "yes (with theme icons)"
		echo -n "checking for gnome-mime-data mime-info path ... "
		echo $DIR_GNOMEMIME
		if test "$DIR_FDMIME" = "no" ; then
			echo -n "checking for gnome-theme path ... "
			echo $DIR_GNOMETHEME
		fi			
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
		echo -n "checking for gnome-mime-data mime-info path ... "
		echo $DIR_GNOMEMIME
		echo -n "checking for pixmaps path ... "
		echo $DIR_PIXMAPS
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
	echo -n "checking for kde-mimelnk path ... "
	echo $DIR_KDEMIME
	echo -n "checking for kde-theme path ... "
	echo $DIR_KDETHEME
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
])
AC_OUTPUT
