<?xml version="1.0" encoding="UTF-8"?>

<!--
  Document  $Id$
  Summary   XSLT stylesheet to convert XML database into a mime.types
            file, as used/provided by apache, mime-support, zope, xfm, ....
  
  Copyright (C) 2007 Daniel Leidert <daniel.leidert@wgdd.de>.

  This file is free software. The copyright owner gives unlimited
  permission to copy, distribute and modify it.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cm="http://chemical-mime.sourceforge.net/chemical-mime"
                xmlns:fdo="http://www.freedesktop.org/standards/shared-mime-info"
                version="1.0">

<!-- ********************************************************************* -->
<!-- * Import XSL stylesheets. Define output options.                      -->
<!-- ********************************************************************* -->

<xsl:import href="cmd_common.xsl"/>
<xsl:output method="text"
            encoding="UTF-8"/>

<!-- ********************************************************************* -->
<!-- * Space-stripped and -preserved elements/tokens.                      -->
<!-- ********************************************************************* -->

<xsl:strip-space elements="*"/>

<!-- ********************************************************************* -->
<!-- * xsl:template match (modes) section                                  -->
<!-- ********************************************************************* -->

<!-- * Output content to 'mime.types'. Then process the whole file.       -->
<xsl:template match="/">
	<xsl:call-template name="common.write.chunk">
		<xsl:with-param name="filename" select="'mime.types'"/>
		<xsl:with-param name="method" select="'text'"/>
		<xsl:with-param name="media-type" select="'text/plain'"/>
		<xsl:with-param name="content">
			<xsl:call-template name="common.header.text"/>
			<xsl:call-template name="mime.types.header.warning"/>
			<xsl:apply-templates select=".//fdo:mime-type[@cm:support = 'yes']">
				<xsl:sort select="@type"/>
			</xsl:apply-templates>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template match="fdo:mime-type">
	<xsl:apply-templates select="fdo:glob[child::cm:conflicts[attribute::mimetypes = 'yes']]" mode="conflicts"/>
	<xsl:value-of select="@type"/>
	<xsl:if test="child::fdo:glob">
		<xsl:call-template name="common.string.output.tabs">
			<xsl:with-param name="my.written.string.length" select="string-length(@type)"/>
			<xsl:with-param name="my.tabs.to.go" select="6"/>
		</xsl:call-template>
	</xsl:if>
	<xsl:apply-templates/>
	<xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="fdo:glob">
	<xsl:choose>
		<xsl:when test="starts-with(@pattern,'*.')">
			<xsl:value-of select="substring-after(@pattern,'*.')"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="@pattern"/>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:if test="position() != last()">
		<xsl:text> </xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="fdo:glob" mode="conflicts">
	<xsl:text># </xsl:text>
	<xsl:value-of select="@pattern"/>
	<xsl:text> may conflict with </xsl:text>
	<xsl:for-each select="cm:conflicts[attribute::mimetypes = 'yes']">
		<xsl:value-of select="@type"/>
	</xsl:for-each>
	<xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="*"/>

<!-- ********************************************************************* -->
<!-- * Named templates for special processing and functions.               -->
<!-- ********************************************************************* -->

<!-- * Just output the completely processed and (maybe) extended output    -->
<!-- * without escaping the content. This saves added acronym templates    -->
<!-- * tags.                                                               -->
<xsl:template name="mime.types.header.warning">
	<xsl:text># The content of this file needs to be copied into /etc/mime.types     &#10;</xsl:text>
	<xsl:text># (mime-support), /etc/apache/mime.types (apache),                     &#10;</xsl:text>
	<xsl:text># /etc/htdig/mime.types (htdig) or ${HOME}/.mime.types. The latter     &#10;</xsl:text>
	<xsl:text># overwrites the content of /etc/mime.types.                           &#10;</xsl:text>
	<xsl:text>&#10;</xsl:text>
	<xsl:text># WARNING: Be warned, that this file only contains extension pattern.  &#10;</xsl:text>
	<xsl:text># Conflicting pattern may lead to issues! So read the comments about   &#10;</xsl:text>
	<xsl:text># conflicts carefully, before you copy the file content as whole or in &#10;</xsl:text>
	<xsl:text># parts into one of the files mentioned above. It may be necessary to  &#10;</xsl:text>
	<xsl:text># solve conflicts manually or extend the system with a content pattern &#10;</xsl:text>
	<xsl:text># detection system like file/libmagic.                                 &#10;</xsl:text>
	<xsl:text>&#10;</xsl:text>
</xsl:template>

</xsl:stylesheet>
