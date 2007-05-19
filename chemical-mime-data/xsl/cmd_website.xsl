<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % _cmd_entities SYSTEM "cmd_entities.dtd">
	%_cmd_entities;
]>

<!--
  Document  $Id$
  Summary   XSLT stylesheet that contains templates used to create the
            projects website.
  
  Copyright (C) 2006,2007 Daniel Leidert <daniel.leidert@wgdd.de>.

  This file is free software. The copyright owner gives unlimited
  permission to copy, distribute and modify it.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cm="http://chemical-mime.sourceforge.net/chemical-mime"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:fdo="http://www.freedesktop.org/standards/shared-mime-info"
                version="1.0"
                extension-element-prefixes="date"
                exclude-result-prefixes="cm date fdo">

<!-- ********************************************************************* -->
<!-- * Import XSL stylesheets. Define output options.                      -->
<!-- ********************************************************************* -->

<xsl:import href="cmd_common.xsl"/>
<xsl:output method="html"
            encoding="UTF-8"
            indent="yes"
            omit-xml-declaration="yes"
            doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

<!-- ********************************************************************* -->
<!-- * Space-stripped and -preserved elements/tokens.                      -->
<!-- ********************************************************************* -->

<xsl:strip-space elements="*"/>

<!-- ********************************************************************* -->
<!-- * xsl:template match (modes) section                                  -->
<!-- ********************************************************************* -->

<xsl:template match="/">
  <!-- * Output content to 'chemical-mime-data.html'.                      -->
  <!-- * Then process the whole file.                                      -->
	<xsl:call-template name="common.write.chunk">
		<xsl:with-param name="filename" select="'chemical-mime-data.html'"/>
		<xsl:with-param name="method" select="'xml'"/>
		<xsl:with-param name="omit-xml-declaration" select="'no'"/>
		<xsl:with-param name="media-type" select="'text/xml'"/>
		<xsl:with-param name="doctype-public" select="'-//W3C//DTD XHTML 1.0 Strict//EN'"/>
		<xsl:with-param name="doctype-system" select="'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'"/>
		<xsl:with-param name="content">
			<xsl:call-template name="html.content"/>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template match="fdo:alias|fdo:sub-class-of">
	<dd>
		<span class="{local-name(.)}">
			<xsl:value-of select="@type"/>
		</span>
	</dd>
</xsl:template>

<xsl:template match="fdo:comment">
	<xsl:variable name="content" select="."/>
	<xsl:choose>
		<xsl:when test="following-sibling::fdo:acronym">
			<xsl:call-template name="comment.acronym.check">
				<xsl:with-param name="content" select="$content"/>
				<xsl:with-param name="acronym.position" select="1"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="comment.acronym.output">
				<xsl:with-param name="content" select="$content"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="fdo:glob">
	<code class="{local-name(.)}">
		<xsl:value-of select="@pattern"/>
	</code>
	<xsl:if test="following-sibling::fdo:glob">
		<xsl:text>, </xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="fdo:magic|fdo:match|fdo:root-XML">
	<xsl:param name="indent.level" select="''"/>
	<xsl:variable name="local.name" select="local-name()"/>

	<xsl:value-of select="$indent.level"/>
	<xsl:text>&lt;</xsl:text>
	<xsl:value-of select="$local.name"/>
	<xsl:for-each select="@*">
		<xsl:text> </xsl:text>
		<xsl:value-of select="local-name()"/>
		<xsl:text>="</xsl:text>
		<xsl:value-of select="." />
		<xsl:text>"</xsl:text>
	</xsl:for-each>
	<xsl:choose>
		<xsl:when test="child::fdo:*">
			<xsl:text>&gt;</xsl:text>
			<br/>
			<xsl:apply-templates>
				<xsl:with-param name="indent.level" select="concat($indent.level,'    ')"/>
			</xsl:apply-templates>
			<xsl:value-of select="$indent.level"/>
			<xsl:text>&lt;/</xsl:text>
			<xsl:value-of select="$local.name"/>
			<xsl:text>&gt;</xsl:text>
			<br/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>/&gt;</xsl:text>
			<br/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="fdo:mime-type">
	<xsl:variable name="count.rowspan" select="number(count(child::fdo:magic[1])
	                                           + count(child::fdo:root-XML[1])
	                                           + count(child::cm:specification[1])
	                                           + 1)"/>
	<tr id="{generate-id(.)}" class="{local-name(.)}">
		<xsl:choose>
			<xsl:when test="$count.rowspan &gt; 1">
				<xsl:call-template name="mimetype.output">
					<xsl:with-param name="rowspan" select="$count.rowspan"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="mimetype.output"/>
			</xsl:otherwise>
		</xsl:choose>
		<td class="comment">
			<xsl:apply-templates select="fdo:comment[not(@xml:lang)]"/>
		</td>
		<td class="glob">
			<xsl:apply-templates select="fdo:glob"/>
		</td>
	</tr>
	<xsl:if test="child::fdo:magic">
		<tr>
			<td colspan="2" class="magic">
				<pre>
					<xsl:apply-templates select="fdo:magic"/>
				</pre>
			</td>
		</tr>
	</xsl:if>
	<xsl:if test="child::fdo:root-XML">
		<tr>
			<td colspan="2" class="root-XML">
				<pre>
					<xsl:apply-templates select="fdo:root-XML"/>
				</pre>
			</td>
		</tr>
	</xsl:if>
	<xsl:if test="child::cm:specification">
		<tr>
			<td colspan="2" class="specification">
				<xsl:apply-templates select="cm:specification"/>
			</td>
		</tr>
	</xsl:if>
</xsl:template>

<xsl:template match="cm:specification">
	<a href="{@url}">
		<xsl:if test="string-length(@title)">
			<xsl:attribute name="title">
				<xsl:value-of select="@title"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:value-of select="@url"/>
	</a>
	<xsl:if test="following-sibling::cm:specification">
		<xsl:text>,</xsl:text>
		<br/>
	</xsl:if>
</xsl:template>

<xsl:template match="*"/>

<!-- ********************************************************************* -->
<!-- * Named templates for special processing and functions.               -->
<!-- ********************************************************************* -->

<xsl:template name="html.content">
  <!-- * Outputs the HTML site. Here we create the <head> section with all -->
  <!-- * meta tags and call the other templates to create the HTML body,   -->
  <!-- * without process anything body-related here.                       --> 
	<html>
		<head>
			<title>The chemical-mime-data Project</title>
			<meta name="generator">
				<xsl:attribute name="content">$Id$</xsl:attribute>
			</meta>
			<meta name="author">
				<xsl:attribute name="content">Daniel Leidert</xsl:attribute>
			</meta>
			<meta name="date">
				<xsl:attribute name="content"><xsl:value-of select="date:date-time()"/></xsl:attribute>
			</meta>
			<meta name="keywords" content="chemical-mime-data, chemical MIME"/>
			<meta name="description" content="chemical-mime-data Homepage"/>
			<meta name="robots" content="index, follow"/>
			<meta http-equiv="content-type" content="application/xhtml+xml; charset=UTF-8"/>
			<meta http-equiv="content-style-type" content="text/css"/>
			<link rel="stylesheet" type="text/css" href="cmd.css" media="screen" title="default" />
		</head>
		<body>
			<div id="content_container">
				<xsl:call-template name="html.content.head"/>
				<xsl:call-template name="html.content.table.mime.supported"/>
				<xsl:call-template name="html.content.table.mime.unsupported"/>
				<xsl:call-template name="html.content.references"/>
			</div>
			<div id="footer">
				<xsl:call-template name="html.content.foot"/>
			</div>
		</body>
	</html>
</xsl:template>

<xsl:template name="html.content.head">
  <!-- * The template contains all static data written at the beginning of   -->
  <!-- * the HTML site(headline/title, about the project, ... such data).    -->
	<h1>chemical-mime-data</h1>
	<p>The source of <a href="index.html">this project</a> can be downloaded at the <a href="http://sourceforge.net/project/showfiles.php?group_id=159685&amp;package_id=179318">Sourceforge.net project page</a>. <span class="sfnet"><a href="http://www.sourceforge.net"><img src="http://sflogo.sourceforge.net/sflogo.php?group_id=159685&amp;type=1" width="88" height="31" style="border: 0;" alt="SourceForge.net Logo"/></a></span></p>
	<p>The released version is: <span class="version">&entversion;</span>.</p>
	<p>The released Database version is: <span class="version"><xsl:value-of select="/fdo:mime-info/@cm:vcsid"/></span>.</p>
	<h2 id="toc">Table of Contents</h2>
	<ol>
		<li><a href="#supported">Supported MIME types</a></li>
		<li><a href="#unsupported">Unsupported but known MIME types</a></li>
		<li><a href="#references">References</a></li>
	</ol>
</xsl:template>

<xsl:template name="html.content.references">
  <!-- * At least print out a list of references.                            -->
	<h2 id="references">References</h2>
	<p>The tables contain references to specifications, standards and papers, that were used. So the following list are generic resources, that were used too.</p>
	<ol>
		<li><a href="http://www.ch.ic.ac.uk/chemime/">&#187;The Chemical MIME Home Page&#171;</a> by Henry Rzepa.</li>
	</ol>
</xsl:template>

<xsl:template name="html.content.table.mime.supported">
  <!-- * Output an overview of currently (by the package) supported MIME     -->
  <!-- * types.                                                              -->
	<h2 id="supported">Supported MIME types</h2>
	<p>The following MIME types are supported by the &entpackage; package version &entversion;.</p>
	<table>
		<xsl:call-template name="html.content.table.mime.head"/>
		<xsl:apply-templates select=".//fdo:mime-type[@cm:support = 'yes']">
			<xsl:sort select="@type"/>
		</xsl:apply-templates>
	</table>
</xsl:template>

<xsl:template name="html.content.table.mime.unsupported">
  <!-- * Output an overview of currently (by the package) unsupported, but   -->
  <!-- * known and already added MIME types.                                 -->
	<h2 id="unsupported">Unsupported but known MIME types</h2>
	<p>The following MIME types are not supported by the &entpackage; package version &entversion;.</p>
	<table>
		<xsl:call-template name="html.content.table.mime.head"/>
		<xsl:apply-templates select=".//fdo:mime-type[not(@cm:support = 'yes')]">
			<xsl:sort select="@type"/>
		</xsl:apply-templates>
	</table>
	<p>There might be more MIME types, that simply were not yet added to the database. If you know one missing, just <a href="https://sourceforge.net/tracker/?func=add&amp;group_id=159685&amp;atid=812822">let us know</a>.</p>
</xsl:template>

<xsl:template name="html.content.table.mime.head">
  <!-- * Both overviews have the same table head. This template creates    -->
  <!-- * it.                                                               -->
	<tr>
		<th class="mime-type" rowspan="4">MIME type
			<br/><br/>Sub-class of <sup>[<a href="#comment_subclassof">1</a>]</sup>
			<br/><br/>Alias
		</th>
		<th class="comment">Description</th>
		<th class="glob">Filename extension</th>
	</tr>
	<tr>
		<th class="magic" colspan="2">Magic Pattern</th>
	</tr>
	<tr>
		<th class="root-XML" colspan="2">Root XML/Namespace</th>
	</tr>
	<tr>
		<th class="specification" colspan="2">Specification</th>
	</tr>
</xsl:template>

<xsl:template name="html.content.foot">
  <!-- * The template contains all static data written at the beginning of   -->
  <!-- * the HTML site(headline/title, about the project, ... such data).    -->
 	<span id="comment_subclassof"><sup><strong>[1]</strong></sup> Entries, that do not show a <cite>Sub-class of:</cite> value are binary files and therefor of type <span class="sub-class-of">application/octet-stream</span>.</span>
</xsl:template>

<xsl:template name="mimetype.output">
  <!-- * For every MIME type, create a cell with the following content:    -->
  <!-- *                                                                   -->
  <!-- * chemical/foo                                                      -->
  <!-- *                                                                   -->
  <!-- * Sub-class of:                                                     -->
  <!-- *     MIME type                                                     -->
  <!-- *                                                                   -->
  <!-- * Alias(s):                                                         -->
  <!-- *     MIME type 1                                                   -->
  <!-- *     MIME type 2                                                   -->
  <!-- *     ...                                                           -->
  <!-- *                                                                   -->
	<xsl:param name="rowspan" select="false()"/>
	
	<td class="{local-name(.)}">
		<xsl:if test="$rowspan">
			<xsl:attribute name="rowspan">
				<xsl:value-of select="$rowspan"/>
			</xsl:attribute>
		</xsl:if>
		<span class="{local-name(.)}">
			<xsl:value-of select="@type"/>
		</span>
		<xsl:if test="child::fdo:sub-class-of">
			<dl>
				<dt class="sub-class-of">Sub-class of:</dt>
				<xsl:apply-templates select="fdo:sub-class-of">
					<xsl:sort select="@type"/>
				</xsl:apply-templates>
			</dl>
		</xsl:if>
		<xsl:if test="child::fdo:alias">
			<dl>
				<dt class="alias">Alias(s):</dt>
				<xsl:apply-templates select="fdo:alias">
					<xsl:sort select="@type"/>
				</xsl:apply-templates>
			</dl>
		</xsl:if>
	</td>
</xsl:template>

<xsl:template name="comment.acronym.check">
  <!-- * Process the content of a <comment> and check, if the comment      -->
  <!-- * contains the content of a <acronym>/<expanded-acronym> combo of   -->
  <!-- * the currently processed <mime-type> element. If an a known        -->
  <!-- * <acronym> is found, it's pure text is replaced with the acronym   -->
  <!-- * HTML tag. Ditto, if the <expanded-acronym> content fits a part of -->
  <!-- * the currently processed <comment> content.                        -->
	<xsl:param name="content"/>
	<xsl:param name="acronym.position"/>

	<xsl:variable name="acronym.content"
	              select="following-sibling::fdo:acronym[not(@xml:lang)][$acronym.position]"/>
	<xsl:variable name="expanded.acronym.content"
	              select="following-sibling::fdo:expanded-acronym[not(@xml:lang)][$acronym.position]"/>

	<xsl:choose>
    <!-- * Check if we find a known <acronym> inside <comment>. If yes,    -->
    <!-- * use the <acronym> HTML tag with the contents of <acronym> and   -->
    <!-- * <expanded-acronym> of our database.                             -->
		<xsl:when test="contains($content, $acronym.content)">
			<xsl:variable name="content.new.before" select="substring-before($content, $acronym.content)"/>
			<xsl:variable name="content.new.acronym">
				<![CDATA[<acronym title="]]><xsl:value-of select="$expanded.acronym.content"/>
				<![CDATA[">]]><xsl:value-of select="$acronym.content"/><![CDATA[</acronym>]]>
			</xsl:variable>
			<xsl:variable name="content.new.middle" select="normalize-space($content.new.acronym)"/>
			<xsl:variable name="content.new.after" select="substring-after($content, $acronym.content)"/>
			<xsl:variable name="content.new" select="concat($content.new.before, $content.new.middle, $content.new.after)"/>
			<xsl:choose>
				<xsl:when test="following-sibling::fdo:acronym[not(@xml:lang)][$acronym.position + 1]">
					<xsl:call-template name="comment.acronym.check">
						<xsl:with-param name="content" select="$content.new"/>
						<xsl:with-param name="acronym.position" select="$acronym.position + 1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="comment.acronym.output">
						<xsl:with-param name="content" select="$content.new"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>			
    <!-- * Check, if maybe a part of the comment fits the content of an    -->
    <!-- * <expanded-acronym>. If yes, output the related <acronym>        -->
    <!-- * directly behind the (expanded) substring inside braces, using   -->
    <!-- * the <acronym> HTML tag.                                         -->
		<xsl:when test="contains($content, $expanded.acronym.content)">
			<xsl:variable name="content.new.before" select="concat(substring-before($content, $expanded.acronym.content), $expanded.acronym.content)"/>
			<xsl:variable name="content.new.acronym">
				<![CDATA[<acronym title="]]><xsl:value-of select="$expanded.acronym.content"/>
				<![CDATA[">]]><xsl:value-of select="$acronym.content"/><![CDATA[</acronym>]]>
			</xsl:variable>
			<xsl:variable name="content.new.middle.before" select="' ('"/>
			<xsl:variable name="content.new.middle.temp" select="normalize-space($content.new.acronym)"/>
			<xsl:variable name="content.new.middle.after" select="') '"/>
			<xsl:variable name="content.new.middle" select="concat($content.new.middle.before, $content.new.middle.temp, $content.new.middle.after)"/>
			<xsl:variable name="content.new.after" select="substring-after($content, $expanded.acronym.content)"/>
			<xsl:variable name="content.new" select="concat($content.new.before, $content.new.middle, $content.new.after)"/>
			<xsl:choose>
				<xsl:when test="following-sibling::fdo:acronym[not(@xml:lang)][$acronym.position + 1]">
					<xsl:call-template name="comment.acronym.check">
						<xsl:with-param name="content" select="$content.new"/>
						<xsl:with-param name="acronym.position" select="$acronym.position + 1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="comment.acronym.output">
						<xsl:with-param name="content" select="$content.new"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
    <!-- * And if nothing fits, just step to the next <acronym> position   -->
    <!-- * in our database.                                                -->
		<xsl:otherwise>
			<xsl:variable name="content.new" select="$content"/>
			<xsl:choose>
				<xsl:when test="following-sibling::fdo:acronym[not(@xml:lang)][$acronym.position + 1]">
					<xsl:call-template name="comment.acronym.check">
						<xsl:with-param name="content" select="$content.new"/>
						<xsl:with-param name="acronym.position" select="$acronym.position + 1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="comment.acronym.output">
						<xsl:with-param name="content" select="$content.new"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="comment.acronym.output">
  <!-- * Just output the completely processed and (maybe) extended output  -->
  <!-- * without escaping the content. This saves added acronym templates  -->
  <!-- * tags.                                                             -->
	<xsl:param name="content"/>

	<xsl:value-of select="$content" disable-output-escaping="yes"/>
</xsl:template>

</xsl:stylesheet>
