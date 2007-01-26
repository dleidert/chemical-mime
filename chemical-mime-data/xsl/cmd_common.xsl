<?xml version="1.0" encoding="UTF-8"?>

<!--
  Document  $Id$
  Summary   XSLT stylesheet that contains commonly used templates.
  
  Copyright (C) 2006,2007 Daniel Leidert <daniel.leidert@wgdd.de>.

  This file is free software. The copyright owner gives unlimited
  permission to copy, distribute and modify it.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:redirect="http://xml.apache.org/xalan/redirect"
                xmlns:exslt="http://exslt.org/common"
                version="1.0"
                extension-element-prefixes="saxon redirect lxslt exslt">


<!-- ********************************************************************* -->
<!-- * Named templates for common functions.                               -->
<!-- ********************************************************************* -->

<xsl:template name="common.header.text">
  <!-- * A created text file shall contain a header with information about -->
  <!-- * the license and the database version.                             -->
	<xsl:text>#  This file is part of the chemical-mime-data package.
#  It is distributed under the GNU Lesser General Public License version 2.1.
#
#  Database: </xsl:text><xsl:value-of select="chemical-mime/@id"/><xsl:text>&#10;&#10;&#10;</xsl:text>
</xsl:template>

<xsl:template name="common.header.xml">
  <!-- * A created xml file shall contain a header with information about  -->
  <!-- * the license and the database version.                             -->
	<xsl:comment>
		<xsl:text>
  This file is part of the chemical-mime-data package.
  It is distributed under the GNU Lesser General Public License version 2.1.

  Database: </xsl:text>
		<xsl:value-of select="chemical-mime/@id"/>
		<xsl:text>&#10;</xsl:text>
	</xsl:comment>
	<xsl:text>&#10;&#10;</xsl:text>
</xsl:template>

<xsl:template name="common.write.chunk">
  <!-- * This template output the given content into a file with the given -->
  <!-- * filename, encoding and media type. With this template we can      -->
  <!-- * write several output files from one input file. Therefor we need  -->
  <!-- * several extensions. The default is EXSLT, which is implemented in -->
  <!-- * linxslt1.1 (xsltproc). The other are nice to have, but unused     -->
  <!-- * atm.                                                              -->
	<xsl:param name="filename" select="''"/>
	<xsl:param name="method" select="''"/>
	<xsl:param name="indent" select="''"/>
	<xsl:param name="omit-xml-declaration" select="''"/>
	<xsl:param name="media-type" select="''"/>
	<xsl:param name="doctype-public" select="''"/>
	<xsl:param name="doctype-system" select="''"/>
	<xsl:param name="content"/>

	<xsl:choose>
    <!-- * Check if EXSLT's exslt:document() is available.                 -->
		<xsl:when test="element-available('exslt:document')">
			<xsl:choose>
				<xsl:when test="$doctype-public != '' and $doctype-system != ''">
					<exslt:document href="{$filename}"
					               method="{$method}"
					               encoding="UTF-8"
					               indent="{$indent}"
					               omit-xml-declaration="{$omit-xml-declaration}"
					               media-type="{$media-type}"
					               doctype-public="{$doctype-public}"
					               doctype-system="{$doctype-system}">
						<xsl:copy-of select="$content"/>
					</exslt:document>
				</xsl:when>
				<xsl:otherwise>
					<exslt:document href="{$filename}"
					               method="{$method}"
					               encoding="UTF-8"
					               indent="{$indent}"
					               omit-xml-declaration="{$omit-xml-declaration}"
					               media-type="{$media-type}">
						<xsl:copy-of select="$content"/>
					</exslt:document>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
    <!-- * Check if Saxon's saxon:output() is available.                   -->
		<xsl:when test="element-available('saxon:output')">
			<xsl:choose>
				<xsl:when test="$doctype-public != '' and $doctype-system != ''">
					<saxon:output saxon:character-representation="'entity;decimal'"
					              href="{$filename}"
					              method="{$method}"
					              encoding="UTF-8"
					              indent="{$indent}"
					              omit-xml-declaration="{$omit-xml-declaration}"
					              media-type="{$media-type}"
					              doctype-public="{$doctype-public}"
					              doctype-system="{$doctype-system}">
						<xsl:copy-of select="$content"/>
					</saxon:output>
				</xsl:when>
				<xsl:otherwise>
					<saxon:output saxon:character-representation="'entity;decimal'"
					              href="{$filename}"
					              method="{$method}"
					              encoding="UTF-8"
					              indent="{$indent}"
					              omit-xml-declaration="{$omit-xml-declaration}"
					              media-type="{$media-type}">
						<xsl:copy-of select="$content"/>
					</saxon:output>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
    <!-- * Check if Xalan's redirect:write() is available.                 -->
		<xsl:when test="element-available('redirect:write')">
			<redirect:write file="{$filename}">
				<xsl:copy-of select="$content"/>
			</redirect:write>
		</xsl:when>
		<xsl:otherwise>
      <!-- * And if nothing of these are available, output an error.       -->
			<xsl:message terminate="yes">
				<xsl:text>Can't make chunks with </xsl:text>
				<xsl:value-of select="system-property('xsl:vendor')"/>
				<xsl:text>'s processor.</xsl:text>
			</xsl:message>
		</xsl:otherwise>
	</xsl:choose>
	
  <!-- * Be verbose, which file is output.                                 -->
	<xsl:message>
		<xsl:text>Writing </xsl:text>
		<xsl:value-of select="$filename"/>
		<xsl:text>.</xsl:text>
	</xsl:message>
</xsl:template>

</xsl:stylesheet>

