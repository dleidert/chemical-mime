<?xml version="1.0" encoding="UTF-8"?>

<!--
  Document  $Id$
  Summary   XSLT stylesheet for creating an XML file from the plain
            text KDE mimelnk .desktop files.
  
  Copyright (C) 2007 Daniel Leidert <daniel.leidert@wgdd.de>.

  This file is free software. The copyright owner gives unlimited
  permission to copy, distribute and modify it.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:str="http://exslt.org/strings"
                extension-element-prefixes="str"
                exclude-result-prefixes="str"
                version="1.0">

<!-- ********************************************************************* -->
<!-- * Import XSL stylesheets. Define output options.                      -->
<!-- ********************************************************************* -->

<xsl:output method="xml"
            encoding="UTF-8"
            indent="yes"
            media-type="text/xml"
            omit-xml-declaration="no"/>

<!-- ********************************************************************* -->
<!-- * Space-stripped and -preserved elements/tokens.                      -->
<!-- ********************************************************************* -->

<xsl:preserve-space elements="desktop-entry"/>
<xsl:strip-space elements="*"/>

<!-- ********************************************************************* -->
<!-- * xsl:template match (modes) section                                  -->
<!-- ********************************************************************* -->

<xsl:template match="/">
  <!-- * Put the content of the faked XML structure into a node set to     -->
  <!-- * make it possible to select the MIME-Type and every single         -->
  <!-- * extension pattern of the plain KDE mimelnk .desktop files as      -->
  <!-- * single XML node. Then put it into a real XML structure.           -->
	<xsl:comment> * This file was created automatically by kde-mimelnk.xsl. Do not    </xsl:comment>
	<xsl:comment> * edit it by hand. It's just for temporary usage during the         </xsl:comment>
	<xsl:comment> * `make (dist)check' target.                                        </xsl:comment>
	<kde-mimelnk>
		<xsl:apply-templates/>
	</kde-mimelnk>
</xsl:template>

<xsl:template match="desktop-entry">
  <!-- * Put the content of the faked XML structure into a node set to     -->
  <!-- * make it possible to select the MIME-Type and every single         -->
  <!-- * extension pattern of the plain KDE mimelnk .desktop files as      -->
  <!-- * single XML node. Then put it into a real XML structure.           -->
	<xsl:variable name="token.content" select="str:tokenize(string(.),'&#10;')"/>
	
	<xsl:for-each select="$token.content">
		<xsl:if test="starts-with(normalize-space(.),'Patterns=')
		              and string(substring-after(normalize-space(.),'Patterns='))">

			<xsl:variable name="node.alias">
				<xsl:choose>
					<xsl:when test="following-sibling::token[starts-with(normalize-space(),'X-KDE-IsAlso=')]">
						<xsl:value-of select="following-sibling::token[starts-with(normalize-space(),'X-KDE-IsAlso=')]"/>
					</xsl:when>
					<xsl:when test="preceding-sibling::token[starts-with(normalize-space(),'X-KDE-IsAlso=')]">
						<xsl:value-of select="preceding-sibling::token[starts-with(normalize-space(),'X-KDE-IsAlso=')]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="false()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="node.mime">
				<xsl:choose>
					<xsl:when test="following-sibling::token[starts-with(normalize-space(),'MimeType=')]">
						<xsl:value-of select="following-sibling::token[starts-with(normalize-space(),'MimeType=')]"/>
					</xsl:when>
					<xsl:when test="preceding-sibling::token[starts-with(normalize-space(),'MimeType=')]">
						<xsl:value-of select="preceding-sibling::token[starts-with(normalize-space(),'MimeType=')]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'unknown/unknown'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="node.alias.tmp" select="substring-after($node.alias,'X-KDE-IsAlso=')"/>
			<xsl:variable name="node.mime.tmp" select="substring-after($node.mime,'MimeType=')"/>
			<xsl:variable name="node.pattern.tmp" select="substring-after(.,'Patterns=')"/>

			<xsl:call-template name="compare.token.content">
				<xsl:with-param name="node.alias" select="$node.alias.tmp"/>
				<xsl:with-param name="node.mime" select="$node.mime.tmp"/>
				<xsl:with-param name="node.pattern" select="$node.pattern.tmp"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:for-each>
</xsl:template>

<!-- ********************************************************************* -->
<!-- * Named templates for special processing and functions.               -->
<!-- ********************************************************************* -->

<xsl:template name="compare.token.content">
  <!-- * Create an XML file from the plain KDE mimelnk database by using   -->
  <!-- * the nodes created earlier. The structure is nearly similar to the -->
  <!-- * shared-mime-info XML database, but misses all the information,    -->
  <!-- * that cannot be extracted from a kde mimelnk .desktop file,        -->
  <!-- * because the .desktop file(s) does not contain such data.          -->
	<xsl:param name="node.alias" select="false()"/>
	<xsl:param name="node.mime"/>
	<xsl:param name="node.pattern"/>
	
	<mime-type type="{$node.mime}">
		<xsl:if test="$node.alias">
			<alias type="{$node.alias}"/>
		</xsl:if>
		<xsl:for-each select="str:tokenize($node.pattern,';')">
			<xsl:sort select="."/>
			<glob pattern="{.}"/>
		</xsl:for-each>
	</mime-type>
</xsl:template>

</xsl:stylesheet>

