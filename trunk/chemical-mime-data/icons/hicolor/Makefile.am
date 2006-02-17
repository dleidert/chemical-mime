# Document  $Id$
# Summary   Makefile for the chemical-mime-data project.
#
# Copyright (C) 2004-2006 by Daniel Leidert.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

EXTRA_DIST = $(icon_sources)

CLEANFILES = *.png *.svgz

MAINTAINERCLEANFILES = Makefile.in


icon_sources = gnome-mime-chemical.svg
icon_sizes   = 16 22 24 32 36 48 64 72 96 128 192


if BOOL_GNOME_THEME

%.svgz : %.svg
	gzip $< -c > $@
	for size in $(icon_sizes) ; do \
		if test "x$(RSVG)" != "x" ; then \
			$(RSVG) -w $${size} -h $${size} -f png $< $*_$${size}.png ; \
		else \
			$(CONVERT) $< -resize $${size}x$${size} $*_$${size}.png ; \
		fi \
	done

all-local: $(icon_sources:.svg=.svgz)

install-data-local:
	$(mkinstalldirs) $(DESTDIR)$(DIR_GNOMETHEME)
	for file in $(icon_sources) ; do \
		icon=`echo $${file} | sed -e 's/\.svg$$//'` ; \
		$(mkinstalldirs) $(DESTDIR)$(DIR_GNOMETHEME)/scalable/mimetypes ; \
		$(INSTALL_DATA) $${icon}.svgz $(DESTDIR)$(DIR_GNOMETHEME)/scalable/mimetypes ; \
		for size in $(icon_sizes) ; do \
			$(mkinstalldirs) $(DESTDIR)$(DIR_GNOMETHEME)/$${size}x$${size}/mimetypes ; \
			$(INSTALL_DATA) $${icon}_$${size}.png $(DESTDIR)$(DIR_GNOMETHEME)/$${size}x$${size}/mimetypes/$${icon}.png ; \
		done \
	done

uninstall-hook:
	for file in $(icon_sources) ; do \
		icon=`echo $${file} | sed -e 's/\.svg$$//'` ; \
		rm -f $(DESTDIR)$(DIR_GNOMETHEME)/scalable/mimetypes/$${icon}.svgz ; \
		for size in $(icon_sizes) ; do \
			rm -f $(DESTDIR)$(DIR_GNOMETHEME)/$${size}x$${size}/mimetypes/$${icon}.png ; \
		done \
	done

endif #BOOL_GNOME_THEME

