# Document  $Id$
# Summary   Makefile for the chemical-mime-data project.
#
# Copyright (C) 2004-2006 by Daniel Leidert.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

SUBDIRS = src xsl freedesktop.org gnome kde icons po

AUTOMAKE_OPTIONS = check-news dist-bzip2

EXTRA_DIST = \
	HACKING \
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
	config.guess \
	config.sub \
	install-sh \
	intltool-extract.in \
	intltool-merge.in \
	intltool-update.in \
	missing \
	mkinstalldirs \
	Makefile.in \
	@PACKAGE@-@VERSION@.tar.{gz,bz2} \
	@PACKAGE@-@VERSION@.tar.{gz,bz2}.md5

DISTCHECK_CONFIGURE_FLAGS = --disable-update-database --disable-nls


pkgconfigdir = $(datadir)/pkgconfig
pkgconfig_DATA = chemical-mime-data.pc

