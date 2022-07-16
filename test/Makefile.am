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
	mime-types.xsl

MOSTLYCLEANFILES = \
	$(MIME_SUPPORT_MIME_TYPES_XML)

MAINTAINERCLEANFILES = Makefile.in


VPATH += $(top_builddir)/src .


MIME_SUPPORT_MIME_TYPES_XML = mime-types.xml

XSLTPROC_FLAGS += --path "$(VPATH)"


check-local: check-pattern

check-pattern: \
	check-pattern-fdo-smi-db \
	check-pattern-mime-types-db

check-pattern-fdo-smi-db: $(FDO_SHARED_MIME_INFO_DB) compare_pattern.xsl chemical-mime-database.xml
	@echo -e "\033[1mCheck the database against the shared-mime-info db.\033[0m"
	$(XSLTPROC) $(XSLTPROC_FLAGS) \
	 --stringparam database "$(FDO_SHARED_MIME_INFO_DB)" \
	 --stringparam database.type "fdo" \
	 --stringparam database.uri \
	 $^

check-pattern-mime-types-db: $(MIME_SUPPORT_MIME_TYPES_XML) compare_pattern.xsl chemical-mime-database.xml 
	@echo -e "\033[1mCheck the database against the mime.types db.\033[0m"
	$(XSLTPROC) $(XSLTPROC_FLAGS) \
	 --stringparam database "$(MIME_SUPPORT_MIME_TYPES_DATA_DB)" \
	 --stringparam database.type "mime.types" \
	 --stringparam database.uri \
	 $^


$(MIME_SUPPORT_MIME_TYPES_XML): mime-types.xsl $(MIME_SUPPORT_MIME_TYPES_DATA_DB)
	@echo -e "\033[1mBuild temporary mime.types database in XML format.\033[0m"
	echo '$(MIME_SUPPORT_MIME_TYPES_XML_CUSTOM)' | $(XSLTPROC) -o $@ $(XSLTPROC_FLAGS) --xinclude $< -
	

include $(srcdir)/Makefile.incl

