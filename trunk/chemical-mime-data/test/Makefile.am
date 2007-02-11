# Document  $Id$
# Summary   Makefile for the chemical-mime-data project.
#
# Copyright (C) 2007 by Daniel Leidert <daniel.leidert@wgdd.de>.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

include $(srcdir)/Makefile.incl

EXTRA_DIST = \
	Makefile.incl \
	compare_pattern.xsl \
	gnome-vfs-mime.xsl

MOSTLYCLEANFILES = $(GNOME_VFS_MIME_XML)

MAINTAINERCLEANFILES = Makefile.in


VPATH += $(top_builddir)/src .


GNOME_VFS_MIME_XML = gnome-vfs-mime.xml

XSLTPROC_FLAGS += --path "$(VPATH)"


check-local: check-fdo-smi-db check-gnome-vfs-db

check-fdo-smi-db: $(FDO_SHARED_MIME_INFO_DB) compare_pattern.xsl chemical-mime-database.xml
	@echo -e "\033[1mCheck the database against the shared-mime-info db.\033[0m"
	$(XSLTPROC) $(XSLTPROC_FLAGS) --stringparam database.type "fdo" --stringparam database.uri $^

check-gnome-vfs-db: $(GNOME_VFS_MIME_XML) compare_pattern.xsl chemical-mime-database.xml 
	@echo -e "\033[1mCheck the database against the gnome-mime-data db.\033[0m"
	$(XSLTPROC) $(XSLTPROC_FLAGS) --stringparam database.type "gnome" --stringparam database.uri $^

$(GNOME_VFS_MIME_XML): gnome-vfs-mime.xsl $(GNOME_VFS_MIME_DATA_DB)
	@echo -e "\033[1mBuild temporary gnome-vfs mime-info database in XML format.\033[0m"
	echo '$(GNOME_VFS_MIME_XML_CUSTOM)' | $(XSLTPROC) -o $@ $(XSLTPROC_FLAGS) --xinclude $< -

