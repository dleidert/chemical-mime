# Document  $Id$
# Summary   Makefile for the chemical-mime-data project.
#
# Copyright (C) 2004-2007 by Daniel Leidert <daniel.leidert@wgdd.de>.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

CLEANFILES = \
	$(kdemagic_DATA) \
	$(kdemime_DATA)

MAINTAINERCLEANFILES = Makefile.in


VPATH += $(top_builddir)/src $(top_srcdir)/xsl 


XSLTPROC_FLAGS +=  --stringparam file.magic.mode "kde"


if BOOL_KDE_MIME
kdemagicdir   = $(pkgdatadir)/kde
kdemagic_DATA = magic

kdemimedir   = $(with_kde_mime)/chemical
kdemime_DATA = *.desktop
endif #BOOL_KDE_MIME


*.desktop : cmd_kde.xsl chemical-mime-database.xml
	$(XSLTPROC) $(XSLTPROC_FLAGS) $^

magic: cmd_file-magic.xsl chemical-mime-database.xml
	$(XSLTPROC) $(XSLTPROC_FLAGS) $^

