# Document  $Id$
# Summary   Makefile for the chemical-mime-data project.
#
# Copyright (C) 2007 by Daniel Leidert <daniel.leidert@wgdd.de>.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

EXTRA_DIST = \
	Makefile.incl \
	compare_pattern.xsl \
	gnome-vfs-mime.xsl \
	kde-mimelnk.xsl \
	mime-types.xsl

MOSTLYCLEANFILES = \
	$(GNOME_VFS_MIME_XML) \
	$(KDE_MIMELNK_XML) \
	$(MIME_SUPPORT_MIME_TYPES_XML)

MAINTAINERCLEANFILES = Makefile.in


VPATH += $(top_builddir)/src .


GNOME_VFS_MIME_XML          = gnome-vfs-mime.xml
KDE_MIMELNK_XML             = kde-mimelnk.xml
MIME_SUPPORT_MIME_TYPES_XML = mime-types.xml

XSLTPROC_FLAGS += --path "$(VPATH)"


check-local: check-pattern

check-pattern: \
	check-pattern-fdo-smi-db \
	check-pattern-gnome-vfs-db \
	check-pattern-kde-mimelnk-db \
	check-pattern-mime-types-db

check-pattern-fdo-smi-db: $(FDO_SHARED_MIME_INFO_DB) compare_pattern.xsl chemical-mime-database.xml
	@echo -e "\033[1mCheck the database against the shared-mime-info db.\033[0m"
	$(XSLTPROC) $(XSLTPROC_FLAGS) \
	 --stringparam database "$(FDO_SHARED_MIME_INFO_DB)" \
	 --stringparam database.type "fdo" \
	 --stringparam database.uri \
	 $^

check-pattern-gnome-vfs-db: $(GNOME_VFS_MIME_XML) compare_pattern.xsl chemical-mime-database.xml 
	@echo -e "\033[1mCheck the database against the gnome-mime-data db.\033[0m"
	$(XSLTPROC) $(XSLTPROC_FLAGS) \
	 --stringparam database "$(GNOME_VFS_MIME_DATA_DB)" \
	 --stringparam database.type "gnome" \
	 --stringparam database.uri \
	 $^

check-pattern-kde-mimelnk-db: $(KDE_MIMELNK_XML) compare_pattern.xsl chemical-mime-database.xml 
	@echo -e "\033[1mCheck the database against the gnome-mime-data db.\033[0m"
	$(XSLTPROC) $(XSLTPROC_FLAGS) \
	 --stringparam database "$(KDE_MIMELNK_DATA_DB)" \
	 --stringparam database.type "kde" \
	 --stringparam database.uri \
	 $^

check-pattern-mime-types-db: $(MIME_SUPPORT_MIME_TYPES_XML) compare_pattern.xsl chemical-mime-database.xml 
	@echo -e "\033[1mCheck the database against the mime.types db.\033[0m"
	$(XSLTPROC) $(XSLTPROC_FLAGS) \
	 --stringparam database "$(MIME_SUPPORT_MIME_TYPES_DATA_DB)" \
	 --stringparam database.type "mime.types" \
	 --stringparam database.uri \
	 $^


$(GNOME_VFS_MIME_XML): gnome-vfs-mime.xsl $(GNOME_VFS_MIME_DATA_DB)
	@echo -e "\033[1mBuild temporary gnome-vfs mime-info database in XML format.\033[0m"
	echo '$(GNOME_VFS_MIME_XML_CUSTOM)' | $(XSLTPROC) -o $@ $(XSLTPROC_FLAGS) --xinclude $< -

$(KDE_MIMELNK_XML): kde-mimelnk.xsl $(KDE_MIMELNK_XML_CUSTOM)
	@echo -e "\033[1mBuild temporary kde mimelnk database in XML format.\033[0m"
	$(XSLTPROC) -o $@ $(XSLTPROC_FLAGS) --xinclude $< $(KDE_MIMELNK_XML_CUSTOM)

$(MIME_SUPPORT_MIME_TYPES_XML): mime-types.xsl $(MIME_SUPPORT_MIME_TYPES_DATA_DB)
	@echo -e "\033[1mBuild temporary mime.types database in XML format.\033[0m"
	echo '$(MIME_SUPPORT_MIME_TYPES_XML_CUSTOM)' | $(XSLTPROC) -o $@ $(XSLTPROC_FLAGS) --xinclude $< -
	

include $(srcdir)/Makefile.incl

