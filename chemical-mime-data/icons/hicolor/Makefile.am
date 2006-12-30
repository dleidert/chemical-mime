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

hicolorthemedir = @with_hicolor_theme@


icon_sources = gnome-mime-chemical.svg
icon_sizes   = 16 22 24 32 36 48 64 72 96 128 192


if BOOL_HICOLOR_THEME

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
	$(mkinstalldirs) $(DESTDIR)$(hicolorthemedir)
	for file in $(icon_sources) ; do \
		icon=`echo $${file} | sed -e 's/\.svg$$//'` ; \
		$(mkinstalldirs) $(DESTDIR)$(hicolorthemedir)/scalable/mimetypes ; \
		$(INSTALL_DATA) $${icon}.svgz $(DESTDIR)$(hicolorthemedir)/scalable/mimetypes ; \
		for size in $(icon_sizes) ; do \
			$(mkinstalldirs) $(DESTDIR)$(hicolorthemedir)/$${size}x$${size}/mimetypes ; \
			$(INSTALL_DATA) $${icon}_$${size}.png $(DESTDIR)$(hicolorthemedir)/$${size}x$${size}/mimetypes/$${icon}.png ; \
		done \
	done

uninstall-hook:
	for file in $(icon_sources) ; do \
		icon=`echo $${file} | sed -e 's/\.svg$$//'` ; \
		rm -f $(DESTDIR)$(hicolorthemedir)/scalable/mimetypes/$${icon}.svgz ; \
		for size in $(icon_sizes) ; do \
			rm -f $(DESTDIR)$(hicolorthemedir)/$${size}x$${size}/mimetypes/$${icon}.png ; \
		done \
	done

endif #BOOL_HICOLOR_THEME

