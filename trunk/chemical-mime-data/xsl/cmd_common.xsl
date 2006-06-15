<?xml version="1.0" encoding="UTF-8"?>

<!--
  Document  $Id$
  Summary   XSLT stylesheet that contains commonly used templates.
  
  Copyright (C) 2006 Daniel Leidert <daniel.leidert@wgdd.de>.

  This file is free software. The copyright owner gives unlimited
  permission to copy, distribute and modify it.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:xalanredirect="org.apache.xalan.xslt.extensions.Redirect"
                xmlns:exsl="http://exslt.org/common"
                version="1.0"
                extension-element-prefixes="saxon xalanredirect lxslt exsl">

<!-- 
	This template writes out the specified file.
-->
<xsl:template name="write.chunk">
	<xsl:param name="filename" select="''"/>
	<xsl:param name="method" select="''"/>
	<xsl:param name="indent" select="''"/>
	<xsl:param name="omit-xml-declaration" select="''"/>
	<xsl:param name="media-type" select="''"/>
	<xsl:param name="doctype-public" select="''"/>
	<xsl:param name="doctype-system" select="''"/>
	<xsl:param name="content"/>

	<!--
		Output the specified file.
	-->
	<xsl:choose>
		<!-- exslt:document -->
		<xsl:when test="element-available('exsl:document')">
			<xsl:choose>
				<xsl:when test="$doctype-public != '' and $doctype-system != ''">
					<exsl:document href="{$filename}"
					               method="{$method}"
					               encoding="UTF-8"
					               indent="{$indent}"
					               omit-xml-declaration="{$omit-xml-declaration}"
					               media-type="{$media-type}"
					               doctype-public="{$doctype-public}"
					               doctype-system="{$doctype-system}">
						<xsl:copy-of select="$content"/>
					</exsl:document>
				</xsl:when>
				<xsl:otherwise>
					<exsl:document href="{$filename}"
					               method="{$method}"
					               encoding="UTF-8"
					               indent="{$indent}"
					               omit-xml-declaration="{$omit-xml-declaration}"
					               media-type="{$media-type}">
						<xsl:copy-of select="$content"/>
					</exsl:document>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<!-- saxon:output -->
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
		<!-- xalanredirect -->
		<xsl:when test="element-available('xalanredirect:write')">
			<xalanredirect:write file="{$filename}">
				<xsl:copy-of select="$content"/>
			</xalanredirect:write>
		</xsl:when>
		<xsl:otherwise>
			<!-- it doesn't matter since we won't be making chunks... -->
			<xsl:message terminate="yes">
				<xsl:text>Can't make chunks with </xsl:text>
				<xsl:value-of select="system-property('xsl:vendor')"/>
				<xsl:text>'s processor.</xsl:text>
			</xsl:message>
		</xsl:otherwise>
	</xsl:choose>
	
	<!--
		Now be a bit verbose and tell, which file we wrote.
	-->
	<xsl:message>
		<xsl:text>Writing </xsl:text>
		<xsl:value-of select="$filename"/>
		<xsl:text>.</xsl:text>
	</xsl:message>
</xsl:template>

<!--
	The created text-files all contain the same header.
-->
<xsl:template name="header.desktop">
	<xsl:text>[Desktop Entry]
Encoding=UTF-8
Type=MimeType&#10;</xsl:text>
</xsl:template>

<!--
	Even the created text-files shall contain a short summary with license
	and database version information.
-->
<xsl:template name="header.text">
	<xsl:text>#  This file is part of the chemical-mime-data package.
#  It is distributed under the GNU Lesser General Public License version 2.1.
#
#  Database: </xsl:text><xsl:value-of select="chemical-mime/@id"/><xsl:text>&#10;&#10;&#10;</xsl:text>
</xsl:template>

<!--
	Even the created xml-files shall contain a short summary with license
	and database version information.
-->
<xsl:template name="header.xml">
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

</xsl:stylesheet>