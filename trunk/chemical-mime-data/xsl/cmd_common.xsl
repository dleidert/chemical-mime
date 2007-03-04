<?xml version="1.0" encoding="UTF-8"?>

<!--
  Document  $Id$
  Summary   XSLT stylesheet that contains commonly used templates.
  
  Copyright (C) 2006,2007 Daniel Leidert <daniel.leidert@wgdd.de>.

  This file is free software. The copyright owner gives unlimited
  permission to copy, distribute and modify it.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cm="http://chemical-mime.sourceforge.net/chemical-mime"
                xmlns:exsl="http://exslt.org/common"
                xmlns:fdo="http://www.freedesktop.org/standards/shared-mime-info"
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:redirect="http://xml.apache.org/xalan/redirect"
                xmlns:saxon="http://icl.com/saxon"
                extension-element-prefixes="cm exsl fdo lxslt redirect saxon"
                version="1.0">

<!-- ********************************************************************* -->
<!-- * Named templates for common functions.                               -->
<!-- ********************************************************************* -->

<!-- * A created text file shall contain a header with information about   -->
<!-- * the license and the database version.                               -->
<xsl:template name="common.header.text">
	<xsl:text>#  This file is part of the chemical-mime-data package.
#  It is distributed under the GNU Lesser General Public License version 2.1.
#
#  Database: </xsl:text><xsl:value-of select="/fdo:mime-info/@cm:vcsid"/><xsl:text>&#10;&#10;&#10;</xsl:text>
</xsl:template>

<!-- * A created xml file shall contain a header with information about    -->
<!-- * the license and the database version.                               -->
<xsl:template name="common.header.xml">
	<xsl:comment>
		<xsl:text>
  This file is part of the chemical-mime-data package.
  It is distributed under the GNU Lesser General Public License version 2.1.

  Database: </xsl:text>
		<xsl:value-of select="/fdo:mime-info/@cm:vcsid"/>
		<xsl:text>&#10;</xsl:text>
	</xsl:comment>
	<xsl:text>&#10;&#10;</xsl:text>
</xsl:template>

<!-- * This template output the given content into a file with the given   -->
<!-- * filename, encoding and media type. With this template we can write  -->
<!-- * several output files from one input file. Therefor we need several  -->
<!-- * extensions. The default is EXSLT, which is implemented in           -->
<!-- * libxslt1.1 (xsltproc). The other are nice to have, but unused atm.  -->
<xsl:template name="common.write.chunk">
	<xsl:param name="filename"/>
	<xsl:param name="method"/>
	<xsl:param name="indent" select="'yes'"/>
	<xsl:param name="omit-xml-declaration" select="'yes'"/>
	<xsl:param name="media-type"/>
	<xsl:param name="doctype-public" select="''"/>
	<xsl:param name="doctype-system" select="''"/>
	<xsl:param name="content"/>

	<xsl:choose>
    <!-- * Check if EXSLT's exslt:document() is available.                 -->
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

<!-- * This template was inspired by / adapted from the DocBook-XSL        -->
<!-- * project (http://docbook.sf.net). It get's a string content and a    -->
<!-- * nodeset of strings to substitute and their substitution strings. If -->
<!-- * it finds a match, then it calls a second template, that replaces    -->
<!-- * the match with the new string.                                      -->
<xsl:template name="string.subst.apply.map">
	<xsl:param name="self.content"/>
	<xsl:param name="map.contents"/>
	
	<xsl:variable name="replaced_text">
		<xsl:call-template name="string.subst">
			<xsl:with-param name="string" select="$self.content"/>
			<xsl:with-param name="target" select="$map.contents[1]/@oldstring"/>
			<xsl:with-param name="replacement" select="$map.contents[1]/@newstring"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$map.contents[2]">
			<xsl:call-template name="string.subst.apply.map">
				<xsl:with-param name="self.content" select="$replaced_text"/>
				<xsl:with-param name="map.contents" select="$map.contents[position() &gt; 1]"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$replaced_text"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- * This template was inspired by / adapted from the DocBook-XSL        -->
<!-- * project (http://docbook.sf.net). It get's a string, the target to   -->
<!-- * replace and its replacement. Then it checks, if the string          -->
<!-- * contains the target. If yes, it replaces the target with its        -->
<!-- * replacement and checks the rest of the string by calling the        -->
<!-- * template again with the rest of the stringas parameter.             -->
<xsl:template name="string.subst">
	<xsl:param name="string"/>
	<xsl:param name="target"/>
	<xsl:param name="replacement"/>

	<xsl:choose>
    <!-- * Check, if the string contains the target to replace ...         -->
		<xsl:when test="contains($string, $target)">
			<xsl:variable name="rest">
        <!-- * Call the template again, with the rest of the string found  -->
        <!-- * after the match. This recursively replaces all targets.     -->
				<xsl:call-template name="string.subst">
					<xsl:with-param name="string" select="substring-after($string, $target)"/>
					<xsl:with-param name="target" select="$target"/>
					<xsl:with-param name="replacement" select="$replacement"/>
				</xsl:call-template>
			</xsl:variable>
      <!-- * Now concat the results.                                       -->
			<xsl:value-of select="concat(substring-before($string, $target), $replacement, $rest)"/>
		</xsl:when>
    <!-- * ... otherwise simply output the string.                         -->
		<xsl:otherwise>
			<xsl:value-of select="$string"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
