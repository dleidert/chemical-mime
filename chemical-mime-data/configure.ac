dnl Document  $Id$
dnl Summary   Configure script for the chemical-mime-data project.
dnl
dnl Copyright (C) 2004-2008 Daniel Leidert <daniel.leidert@wgdd.de>.
dnl Copyright (C) 2004-2006 Egon Willighagen <e.willighagen@science.ru.nl>.
dnl All rights reserved.
dnl
dnl This file is free software. The copyright owner gives unlimited
dnl permission to copy, distribute and modify it.

AC_PREREQ([2.59])

dnl --------------------------------------------------------------------------
dnl initialization
dnl --------------------------------------------------------------------------

AC_INIT([chemical-mime-data],[0.1.95],[http://sourceforge.net/projects/chemical-mime/])
AM_INIT_AUTOMAKE([-Wall])
AC_REVISION($Revision$)
AC_CONFIG_SRCDIR(src/chemical-mime-database.xml.in)

dnl --------------------------------------------------------------------------
dnl intltool/gettext
dnl --------------------------------------------------------------------------

ALL_LINGUAS="de fr"
GETTEXT_PACKAGE=AC_PACKAGE_NAME
AC_SUBST([GETTEXT_PACKAGE])
AM_PO_SUBDIRS
IT_PROG_INTLTOOL
ITPROG_VERSION=`intltoolize --version | awk '{print $4}'`
ITPROG_VERSION_MILES=`echo $ITPROG_VERSION | cut -f1 -d.`
ITPROG_VERSION_MAJOR=`echo $ITPROG_VERSION | cut -f2 -d.`
ITPROG_VERSION_MINOR=`echo $ITPROG_VERSION | cut -f3 -d.`
test -n "$ITPROG_VERSION_MILES" || ITPROG_VERSION_MILES=0
test -n "$ITPROG_VERSION_MAJOR" || ITPROG_VERSION_MAJOR=0
test -n "$ITPROG_VERSION_MINOR" || ITPROG_VERSION_MINOR=0
ITPROG_VERSION_ALL=`expr $ITPROG_VERSION_MILES '*' 1000000 + $ITPROG_VERSION_MAJOR '*' 1000 + $ITPROG_VERSION_MINOR`
AC_MSG_CHECKING([for intltool >= 0.35.0])
if test "$ITPROG_VERSION_ALL" -lt 35000; then
	AC_MSG_RESULT([no])
	USE_NLS=no
	AC_SUBST([USE_NLS])
	CATOBJEXT=.gmo
	AC_SUBST([CATOBJEXT])
else
	AC_MSG_RESULT([yes])
fi

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
	AS_HELP_STRING(
		[--enable-update-database],
		[
		 enable (or disable) the running of the update-mime-database utility after installation
		 @<:@default=yes@:>@
		]
	),
	[enable_update_database=$enableval],
	[enable_update_database=yes]
)

dnl Choose to run rsvg or convert if both are installed
AC_ARG_ENABLE(
	[convert],
	AS_HELP_STRING(
		[--enable-convert],
		[
		 enable or disable the usage of convert (imagemagick) if both rsvg and convert are available
		 @<:@default=no@:>@
		]
	),
	[enable_convert=$enableval],
	[enable_convert=no]
)

dnl --------------------------------------------------------------------------
dnl rsvg or convert (imagemagick)
dnl --------------------------------------------------------------------------

AC_ARG_VAR(
	[CONVERT],
	[The 'convert' binary with path. Use it to define or override the location of 'convert'.]
)
AC_PATH_PROG([CONVERT], [convert], [no])
AC_SUBST([CONVERT])

if test "x$enable_convert" != "xyes" -a "x$CONVERT" = "xno" ; then
	AC_ARG_VAR(
		[RSVG],
		[The 'rsvg' binary with path. Use it to define or override the location of 'rsvg'.]
	)
	AC_PATH_PROG([RSVG], [rsvg], [no])
	AC_SUBST([RSVG])
fi

if test "x$RSVG" = "xno" -a "x$CONVERT" = "xno" ; then
	AC_MSG_ERROR([Cannot find rsvg (librsvg binary) or convert (imagemagick). Please install one of them.])
fi

dnl --------------------------------------------------------------------------
dnl installation locations
dnl --------------------------------------------------------------------------

AC_ARG_WITH(
	[freedesktop-mime],
	AS_HELP_STRING(
		[--with-freedesktop-mime@<:@=PATH@:>@],
		[
		 enable, disable or override the installation directory of the freedesktop.org shared MIME info support files
		 @<:@default=$datadir/mime@:>@
		]
	),
	[
	 if test "x$withval" = "xyes" ; then
		 with_freedesktop_mime=${datadir}/mime
	 fi
	],
	[with_freedesktop_mime=${datadir}/mime]
)
AC_SUBST([with_freedesktop_mime])

AC_ARG_WITH(
	[gnome-mime],
	AS_HELP_STRING(
		[--with-gnome-mime@<:@=PATH@:>@],
		[
		 enable, disable or override the installation directory of the old GNOME 2.4 MIME support files
		 @<:@default=$datadir/mime-info@:>@
		]
	),
	[
	 if test "x$withval" = "xyes" ; then
		 with_gnome_mime=${datadir}/mime-info
	 fi
	],
	[with_gnome_mime=${datadir}/mime-info]
)
AC_SUBST([with_gnome_mime])

AC_ARG_WITH(
	[pixmaps],
	AS_HELP_STRING(
		[--with-pixmaps@<:@=PATH@:>@],
		[
		 enable, disable or override the default installation directory of non-themed icons
		 @<:@default=$datadir/pixmaps@:>@
		]
	),
	[
	 if test "x$withval" = "xyes" ; then
		 with_pixmaps=${datadir}/pixmaps
	 fi
	],
	[with_pixmaps=${datadir}/pixmaps]
)
AC_SUBST([with_pixmaps])

AC_ARG_WITH(
	[hicolor-theme],
	AS_HELP_STRING(
		[--with-hicolor-theme@<:@=PATH@:>@],
		[
		 enable, disable or override the theme-directory, where icons should be
		 installed by default (following the standards, this is the hicolor theme)
		 @<:@default=$datadir/icons/hicolor@:>@
		]
	),
	[
	 if test "x$withval" = "xyes" ; then
		 with_hicolor_theme=${datadir}/icons/hicolor
	 fi
	],
	[with_hicolor_theme=${datadir}/icons/hicolor]
)
AC_SUBST([with_hicolor_theme])

AC_PATH_PROG([KDE_CONFIG], [kde-config], [no])

AC_ARG_WITH(
	[kde-magic],
	AS_HELP_STRING(
		[--with-kde-magic@<:@=PATH@:>@],
		[
		 enable, disable or override the installation directory of the KDE 3.x MIME magic snippet files
		 @<:@default=auto(=$sysconfdir/kde3/magic)@:>@
		]
	),
	[
	 if test "x$withval" = "xyes" ; then
		 if test "x$KDE_CONFIG" != "xno" ; then
			 with_kde_magic=`$KDE_CONFIG --install config`/magic
		 else
			 with_kde_magic=${sysconfdir}/kde3/magic
		 fi
	 fi
	],
	[
	 if test "x$KDE_CONFIG" != "xno" ; then
		 with_kde_magic=`$KDE_CONFIG --install config`/magic
	 else
		 with_kde_magic=${sysconfdir}/kde3/magic
	 fi
	]
)
AC_SUBST([with_kde_magic])

AC_ARG_WITH(
	[kde-mime],
	AS_HELP_STRING(
		[--with-kde-mime@<:@=PATH@:>@],
		[
		 enable, disable or override the installation directory of the KDE 3.x MIME support files
		 @<:@default=auto(=$datadir/mimelnk)@:>@
		]
	),
	[
	 if test "x$withval" = "xyes" ; then
		 if test "x$KDE_CONFIG" != "xno" ; then
			 with_kde_mime=`$KDE_CONFIG --install mime`
		 else
			 with_kde_mime=${datadir}/mimelnk
		 fi
	 fi
	],
	[
	 if test "x$KDE_CONFIG" != "xno" ; then
		 with_kde_mime=`$KDE_CONFIG --install mime`
	 else
		 with_kde_mime=${datadir}/mimelnk
	 fi
	]
)
AC_SUBST([with_kde_mime])

dnl --------------------------------------------------------------------------
dnl Check target file locations
dnl --------------------------------------------------------------------------

AC_ARG_VAR(
	[FDO_SHARED_MIME_INFO_DB],
	[
	 The freedesktop.org shared-mime-info database.
	 @<:@default=$datadir/mime/packages/freedesktop.org.xml@:>@
	]
)
if test -z $FDO_SHARED_MIME_INFO_DB; then
	AC_SUBST(
		[FDO_SHARED_MIME_INFO_DB],
		[${datadir}/mime/packages/freedesktop.org.xml]
	)
fi

AC_ARG_VAR(
	[GNOME_VFS_MIME_DATA_DB],
	[
	 The GNOME-VFS mime data database.
	 @<:@default=$datadir/mime-info/gnome-vfs.mime@:>@
	]
)
if test -z $GNOME_VFS_MIME_DATA_DB; then
	AC_SUBST(
		[GNOME_VFS_MIME_DATA_DB],
		[${datadir}/mime-info/gnome-vfs.mime]
	)
fi

AC_ARG_VAR(
	[KDE_MIMELNK_DATA_DB],
	[
	 The KDE mimelnk mime data database path.
	 @<:@default=auto or $datadir/mimelnk@:>@
	]
)
if test -z $KDE_MIMELNK_DATA_DB; then
	if test "x$KDE_CONFIG" != "xno" ; then
		AC_SUBST(
			[KDE_MIMELNK_DATA_DB],
			[`$KDE_CONFIG --install mime`]
		)		
	else
		AC_SUBST(
			[KDE_MIMELNK_DATA_DB],
			[${datadir}/mimelnk]
		)		
	fi
fi
AC_ARG_VAR(
	[MIME_SUPPORT_MIME_TYPES_DATA_DB],
	[
	 The system wide mime.types database (on Debian systems part of mime-support).
	 @<:@default=$sysconfdir/mime.types@:>@
	]
)
if test -z $MIME_SUPPORT_MIME_TYPES_DATA_DB; then
	AC_SUBST(
		[MIME_SUPPORT_MIME_TYPES_DATA_DB],
		[${sysconfdir}/mime.types]
	)
fi

dnl --------------------------------------------------------------------------
dnl necessary checks
dnl --------------------------------------------------------------------------

dnl necessary checks and additions for freedesktop.org shared-mime-info
if test "x$with_freedesktop_mime" != "xno" ; then
	AC_MSG_CHECKING([for shared-mime-info >= 0.12])
	m4_ifdef(
		[PKG_CHECK_EXISTS],
		[PKG_CHECK_EXISTS(
			[shared-mime-info >= 0.12],
			[
			 AC_MSG_RESULT([yes])
			 CHEMICAL_MIME_DEPS="$CHEMICAL_MIME_DEPS shared-mime-info"
			],
			[
			 AC_MSG_RESULT([no])
			 AC_MSG_ERROR([shared-mime-info package missing.])
			]
		 )
		],
		[
		 if ( $PKG_CONFIG shared-mime-info --atleast-version=0.12 ); then
			AC_MSG_RESULT([yes])
			CHEMICAL_MIME_DEPS="$CHEMICAL_MIME_DEPS shared-mime-info"
		 else
			AC_MSG_RESULT([no])
			AC_MSG_ERROR([shared-mime-info package missing.])
		 fi
		]
	)
	AC_ARG_VAR(
		[UPDATE_MIME_DATABASE],
		[
		 The update-mime-database binary with path.
		 Use it to define or override the location of update-mime-database.
		]
	)
	AC_PATH_PROG([UPDATE_MIME_DATABASE], [update-mime-database], [no])
	AC_SUBST([UPDATE_MIME_DATABASE])
fi

dnl necessary checks and additions for old gnome 2.4 mime support
if test "x$with_gnome_mime" != "xno" ; then
	AC_MSG_CHECKING([for gnome-mime-data])
	m4_ifdef(
		[PKG_CHECK_EXISTS],
		[PKG_CHECK_EXISTS(
			[gnome-mime-data-2.0],
			[
			 AC_MSG_RESULT([yes])
			 CHEMICAL_MIME_DEPS="$CHEMICAL_MIME_DEPS gnome-mime-data-2.0"
			],
			[
			 AC_MSG_RESULT([no])
			 AC_MSG_ERROR([gnome-mime-data package missing.])
			]
		 )
		],
		[
		 if ( $PKG_CONFIG gnome-mime-data-2.0 --exists ); then
			AC_MSG_RESULT([yes])
			CHEMICAL_MIME_DEPS="$CHEMICAL_MIME_DEPS gnome-mime-data-2.0"
		 else
			AC_MSG_RESULT([no])
			AC_MSG_ERROR([gnome-mime-data package missing.])
		 fi
		]
	)
fi
AC_SUBST([CHEMICAL_MIME_DEPS])

dnl --------------------------------------------------------------------------
dnl conditions
dnl --------------------------------------------------------------------------

AM_CONDITIONAL([BOOL_FREEDESKTOP_MIME], [test "x$with_freedesktop_mime" != "xno"])
AC_MSG_CHECKING([if freedesktop.org shared MIME-info database file will be installed])
if test "x$with_freedesktop_mime" != "xno" ; then
	AC_MSG_RESULT([yes])
	AC_MSG_CHECKING([for installation path of the freedesktop.org shared MIME-info database files])
	AC_MSG_RESULT([$with_freedesktop_mime])
else
	AC_MSG_RESULT([no])
fi

AM_CONDITIONAL([BOOL_UPDATE_DATABASE], [test "x$enable_update_database" = "xyes" -a "x$UPDATE_MIME_DATABASE" != "xno" -a "x$with_freedesktop_mime" != "xno"])
AC_MSG_CHECKING([if update-mime-database will run])
if test "x$enable_update_database" = "xyes" \
     -a "x$UPDATE_MIME_DATABASE" != "xno" \
     -a "x$with_freedesktop_mime" != "xno" ; then
	AC_MSG_RESULT([yes])
else
	AC_MSG_RESULT([no])
fi

AM_CONDITIONAL([BOOL_GNOME_MIME], [test "x$with_gnome_mime" != "xno"])
AC_MSG_CHECKING([if old GNOME 2.4 MIME support files will be installed])
if test "x$with_gnome_mime" != "xno" ; then
	AC_MSG_RESULT([yes])
	AC_MSG_CHECKING([for installation path of the GNOME 2.4 support files])
	AC_MSG_RESULT([$with_gnome_mime])
else
	AC_MSG_RESULT([no])
fi

AM_CONDITIONAL([BOOL_KDE_MAGIC], [test "x$with_kde_magic" != "xno"])
AC_MSG_CHECKING([if KDE 3.x MIME magic files will be installed])
if test "x$with_kde_magic" != "xno" ; then
	AC_MSG_RESULT([yes])
	AC_MSG_CHECKING([for installation path of the KDE 3.x MIME magic files])
	AC_MSG_RESULT([$with_kde_magic])
else
	AC_MSG_RESULT([no])
fi

AM_CONDITIONAL([BOOL_KDE_MIME], [test "x$with_kde_mime" != "xno"])
AC_MSG_CHECKING([if KDE 3.x MIME definition files will be installed])
if test "x$with_kde_mime" != "xno" ; then
	AC_MSG_RESULT([yes])
	AC_MSG_CHECKING([for installation path of the KDE 3.x MIME definition files])
	AC_MSG_RESULT([$with_kde_mime])
else
	AC_MSG_RESULT([no])
fi

AM_CONDITIONAL([BOOL_HICOLOR_THEME], [test "x$with_hicolor_theme" != "xno"])
AC_MSG_CHECKING([if theme icons will be installed])
if test "x$with_hicolor_theme" != "xno" ; then
	AC_MSG_RESULT([yes])
	AC_MSG_CHECKING([for installation path of theme icons])
	AC_MSG_RESULT([$with_hicolor_theme])
else
	AC_MSG_RESULT([no])
fi

AM_CONDITIONAL([BOOL_PIXMAPS], [test "x$with_pixmaps" != "xno"])
AC_MSG_CHECKING([if non-themed icons will be installed])
if test "x$with_pixmaps" != "xno" ; then
	AC_MSG_RESULT([yes])
	AC_MSG_CHECKING([for installation path of non-theme icons])
	AC_MSG_RESULT([$with_pixmaps])
else
	AC_MSG_RESULT([no])
fi

dnl --------------------------------------------------------------------------
dnl location determination
dnl --------------------------------------------------------------------------

if test "x$datarootdir" = "x" ; then
	AC_SUBST(
		[datarootdir],
		[${datadir}]
	)
fi

if test "x$docdir" = "x" ; then
	AC_SUBST(
		[docdir],
		[m4_ifset(
			[AC_PACKAGE_TARNAME],
			[${datadir}'/doc/${PACKAGE_TARNAME}'],
			[${datadir}'/doc/${PACKAGE}']
		 )
		]
	)
fi

if test "x$htmldir" = "x" ; then
	AC_SUBST(
		[htmldir],
		['${docdir}']
	)
fi

dnl --------------------------------------------------------------------------
dnl output
dnl --------------------------------------------------------------------------

AC_CONFIG_FILES([
	chemical-mime-data.pc
	Makefile
	file/Makefile
	freedesktop.org/Makefile
	gnome/Makefile
	html_docs/Makefile
	icons/Makefile
	icons/hicolor/Makefile
	icons/pixmaps/Makefile
	kde/Makefile
	mime-support/Makefile
	po/Makefile.in
	src/Makefile
	test/Makefile
	xsl/Makefile
	xsl/cmd_entities.dtd
])
AC_OUTPUT
