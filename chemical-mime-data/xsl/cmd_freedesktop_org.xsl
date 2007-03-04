<?xml version="1.0" encoding="UTF-8"?>

<!--
  Document  $Id$
  Summary   XSLT stylesheet to convert XML database into freedesktop.org
            database file.
  
  Copyright (C) 2006,2007 Daniel Leidert <daniel.leidert@wgdd.de>.

  This file is free software. The copyright owner gives unlimited
  permission to copy, distribute and modify it.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cm="http://chemical-mime.sourceforge.net/chemical-mime"
                xmlns:fdo="http://www.freedesktop.org/standards/shared-mime-info"
                exclude-result-prefixes="cm"
                version="1.0">

<!-- ********************************************************************* -->
<!-- * Import XSL stylesheets. Define output options.                      -->
<!-- ********************************************************************* -->

<xsl:import href="cmd_common.xsl"/>
<xsl:output method="xml"
            encoding="UTF-8"
            indent="yes"
            media-type="text/xml"
            omit-xml-declaration="no"/>

<!-- ********************************************************************* -->
<!-- * Space-stripped and -preserved elements/tokens.                      -->
<!-- ********************************************************************* -->

<xsl:strip-space elements="*"/>

<!-- ********************************************************************* -->
<!-- xsl:template match (modes) section                                    -->
<!-- ********************************************************************* -->

<!-- * Output content to 'chemical-mime-data.xml'. Then process the whole  -->
<!-- * file.                                                               -->
<xsl:template match="/">
	<xsl:call-template name="common.write.chunk">
		<xsl:with-param name="filename" select="'chemical-mime-data.xml'"/>
		<xsl:with-param name="method" select="'xml'"/>
		<xsl:with-param name="omit-xml-declaration" select="'no'"/>
		<xsl:with-param name="media-type" select="'text/xml'"/>
		<xsl:with-param name="content">
			<xsl:call-template name="common.header.xml"/>
			<xsl:element name="mime-info" namespace="http://www.freedesktop.org/standards/shared-mime-info">
				<xsl:apply-templates select=".//fdo:mime-type[@cm:support = 'yes']">
					<xsl:sort select="@type"/>
				</xsl:apply-templates>
			</xsl:element>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template match="fdo:mime-type">
	<xsl:comment>
		<xsl:text> * MIME-Type: </xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text> (supported since version </xsl:text>
		<xsl:value-of select="@cm:added"/>
		<xsl:text>) </xsl:text>
	</xsl:comment>
	<xsl:element name="{local-name(.)}" namespace="http://www.freedesktop.org/standards/shared-mime-info">
		<xsl:copy-of select="@type"/>
		<xsl:apply-templates/>
	</xsl:element>
</xsl:template>

<xsl:template match="fdo:*">
	<xsl:element name="{local-name(.)}" namespace="http://www.freedesktop.org/standards/shared-mime-info">
		<xsl:copy-of select="@*"/>
		<xsl:apply-templates/>
	</xsl:element>
</xsl:template>

<xsl:template match="*"/>

</xsl:stylesheet>
