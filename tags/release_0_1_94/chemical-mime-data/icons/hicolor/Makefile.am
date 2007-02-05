# Document  $Id$
# Summary   Makefile for the chemical-mime-data project.
#
# Copyright (C) 2004-2007 by Daniel Leidert <daniel.leidert@wgdd.de>.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

EXTRA_DIST = $(icon_sources)

CLEANFILES = *.png *.svgz

MAINTAINERCLEANFILES = Makefile.in

SUFFIXES = .svg .svgz

icon_sources = gnome-mime-chemical.svg
icon_sizes   = 16 22 24 32 36 48 64 72 96 128 192


if BOOL_HICOLOR_THEME

.svg.svgz:
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
	$(mkinstalldirs) $(DESTDIR)$(with_hicolor_theme)
	for file in $(icon_sources) ; do \
		icon=`echo $${file} | sed -e 's/\.svg$$//'` ; \
		$(mkinstalldirs) $(DESTDIR)$(with_hicolor_theme)/scalable/mimetypes ; \
		$(INSTALL_DATA) $${icon}.svgz $(DESTDIR)$(with_hicolor_theme)/scalable/mimetypes ; \
		for size in $(icon_sizes) ; do \
			$(mkinstalldirs) $(DESTDIR)$(with_hicolor_theme)/$${size}x$${size}/mimetypes ; \
			$(INSTALL_DATA) $${icon}_$${size}.png $(DESTDIR)$(with_hicolor_theme)/$${size}x$${size}/mimetypes/$${icon}.png ; \
		done \
	done

uninstall-hook:
	for file in $(icon_sources) ; do \
		icon=`echo $${file} | sed -e 's/\.svg$$//'` ; \
		rm -f $(DESTDIR)$(with_hicolor_theme)/scalable/mimetypes/$${icon}.svgz ; \
		for size in $(icon_sizes) ; do \
			rm -f $(DESTDIR)$(with_hicolor_theme)/$${size}x$${size}/mimetypes/$${icon}.png ; \
		done \
	done

endif #BOOL_HICOLOR_THEME

