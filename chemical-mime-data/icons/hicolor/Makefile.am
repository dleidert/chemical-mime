# Document  $Id$
# Summary   Makefile for the chemical-mime-data project.
#
# Copyright (C) 2004-2006 by Daniel Leidert.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

EXTRA_DIST = gnome-mime-chemical.svg

CLEANFILES = *.png *.svgz

MAINTAINERCLEANFILES = Makefile.in


ICONS = gnome-mime-chemical

SIZES = 16 22 24 32 36 48 64 72 96 128 192


if BOOL_GNOME_THEME

%.svgz : %.svg
	gzip $< -c > $@
	for size in $(SIZES) ; do \
		if test "x$(RSVG)" != "x" ; then \
			$(RSVG) -w "$$size" -h "$$size" -f png $(top_srcdir)/icons/hicolor/$*.svg $*_"$$size".png ; \
		else \
			$(CONVERT) $(top_srcdir)/icons/hicolor/$*.svg -resize "$$size"x"$$size" $*_"$$size".png ; \
		fi \
	done

all-local: all-icons

all-icons:
	for icon in $(ICONS) ; do \
		$(MAKE) "$$icon".svgz ; \
	done

install-data-local:
	$(mkinstalldirs) $(DESTDIR)$(DIR_GNOMETHEME)
	for icon in $(ICONS) ; do \
		$(mkinstalldirs) $(DESTDIR)$(DIR_GNOMETHEME)/scalable/mimetypes ; \
		$(INSTALL_DATA) "$$icon".svgz $(DESTDIR)$(DIR_GNOMETHEME)/scalable/mimetypes ; \
		for size in $(SIZES) ; do \
			$(mkinstalldirs) $(DESTDIR)$(DIR_GNOMETHEME)/"$$size"x"$$size"/mimetypes ; \
			$(INSTALL_DATA) "$$icon"_"$$size".png $(DESTDIR)$(DIR_GNOMETHEME)/"$$size"x"$$size"/mimetypes/"$$icon".png ; \
		done \
	done

uninstall-hook:
	for icon in $(ICONS) ; do \
		rm -f $(DESTDIR)$(DIR_GNOMETHEME)/scalable/mimetypes/"$$icon".svgz ; \
		for size in $(SIZES) ; do \
			rm -f $(DESTDIR)$(DIR_GNOMETHEME)/"$$size"x"$$size"/mimetypes/"$$icon".png ; \
		done \
	done

endif #BOOL_GNOME_THEME

