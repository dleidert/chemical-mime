
AUTOMAKE_OPTIONS = dist-bzip2

SUBDIRS = po kde icons freedesktop.org gnome

if BOOL_FREEDESKTOP_MIME
pkgconfigdir = $(datadir)/pkgconfig
pkgconfig_DATA = chemical-mime-data.pc
endif

EXTRA_DIST = \
	ChangeLog \
	AUTHORS \
	COPYING \
	INSTALL \
	NEWS \
	README \
	TODO \
	chemical-mime-data.pc.in \
	intltool-extract.in \
	intltool-update.in \
	intltool-merge.in

DISTCLEANFILES = \
	chemical-mime-data.pc \
	intltool-extract \
	intltool-update \
	intltool-merge

MAINTAINERCLEANFILES = \
	aclocal.m4 \
	configure \
	install-sh \
	intltool-extract.in \
	intltool-merge.in \
	intltool-update.in \
	Makefile.in \
	missing \
	mkinstalldirs

DISTCHECK_CONFIGURE_FLAGS = --disable-update-database

# disable check because of update-mime-database issue
#distuninstallcheck:
#	@:

