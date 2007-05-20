<?xml version="1.0" encoding="UTF-8"?>

<!--
  Document  $Id$
  Summary   XSLT stylesheet for creating an XML file from the plain
            text mime.types database.
  
  Copyright (C) 2007 Daniel Leidert <daniel.leidert@wgdd.de>.

  This file is free software. The copyright owner gives unlimited
  permission to copy, distribute and modify it.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fdo="http://www.freedesktop.org/standards/shared-mime-info"
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

<xsl:preserve-space elements="*"/>

<!-- ********************************************************************* -->
<!-- * xsl:template match (modes) section                                  -->
<!-- ********************************************************************* -->

<xsl:template match="/">
  <!-- * Put the content of the faked XML structure into a node set to     -->
  <!-- * make it possible to select the MIME-Type and every single         -->
  <!-- * extension pattern of the plain GNOME-VFS MIME database as single  -->
  <!-- * XML node. Then put it into a real XML structure.                  -->
	<xsl:variable name="token.content" select="str:tokenize(string(.),'&#10;')"/>
	
	<xsl:comment> * This file was created automatically by gnome-mime-vfs.xsl. Do not </xsl:comment>
	<xsl:comment> * edit it by hand. It's just for temporary usage during the         </xsl:comment>
	<xsl:comment> * `make (dist)check' target.                                        </xsl:comment>
	<gnome-vfs-mime>
		<fdo:mime-info>
			<xsl:for-each select="$token.content">
				<xsl:if test="not(starts-with(normalize-space(.),'#')
				              or starts-with(normalize-space(.),'chemical/'))">
					<xsl:variable name="inner.token.content" select="str:tokenize(string(.),'&#09;')"/>
					<xsl:call-template name="compare.token.content">
						<xsl:with-param name="node.mime" select="$inner.token.content[1]"/>
						<xsl:with-param name="node.pattern" select="$inner.token.content[2]"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:for-each>
		</fdo:mime-info>
	</gnome-vfs-mime>
</xsl:template>

<!-- ********************************************************************* -->
<!-- * Named templates for special processing and functions.               -->
<!-- ********************************************************************* -->

<xsl:template name="compare.token.content">
  <!-- * Create an XML file from the plain GNOME-VFS MIME database by      -->
  <!-- * using the nodes created earlier. The structure is nearly similar  -->
  <!-- * to the shared-mime-info XML database, but misses all the data,    -->
  <!-- * that cannot be extracted from a gnome-mime-data database .mime    -->
  <!-- * file, because the database does not contain such data.            -->
	<xsl:param name="node.mime"/>
	<xsl:param name="node.pattern"/>
	
	<fdo:mime-type type="{$node.mime}">
		<xsl:for-each select="str:tokenize($node.pattern)">
			<xsl:sort select="$node.mime"/>
			<fdo:glob pattern="{concat('*.', .)}"/>
		</xsl:for-each>
	</fdo:mime-type>
</xsl:template>

</xsl:stylesheet>

