<?xml version="1.0" encoding="UTF-8"?>

<!--
  Document  $Id$
  Summary   XSLT stylesheet to create the magic.mime database for file(1).
  
  Copyright (C) 2007 Daniel Leidert <daniel.leidert@wgdd.de>.

  This file is free software. The copyright owner gives unlimited
  permission to copy, distribute and modify it.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cm="http://chemical-mime.sourceforge.net/chemical-mime"
                xmlns:exsl="http://exslt.org/common"
                xmlns:fdo="http://www.freedesktop.org/standards/shared-mime-info"
                extension-element-prefixes="exsl"
                exclude-result-prefixes="cm exsl fdo"
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
<!-- * Parameter declaration section.                                      -->
<!-- ********************************************************************* -->

<xsl:param name="file.magic.mode" select="'file'"/>
<xsl:param name="file.magic.name">
	<xsl:value-of select="'magic.mime'"/>
</xsl:param>
<xsl:param name="value.string.subst.map">
	<substitution oldstring=" " newstring="\ "/>
	<substitution oldstring="!" newstring="\!"/>
	<substitution oldstring="&lt;" newstring="\&lt;"/>
	<substitution oldstring="&gt;" newstring="\&gt;"/>
</xsl:param>
<xsl:param name="type.string.subst.map">
	<substitution oldstring="host16" newstring="short"/>
	<substitution oldstring="host32" newstring="long"/>
	<substitution oldstring="big16" newstring="beshort"/>
	<substitution oldstring="big32" newstring="belong"/>
	<substitution oldstring="little16" newstring="leshort"/>
	<substitution oldstring="little32" newstring="lelong"/>
</xsl:param>

<!-- ********************************************************************* -->
<!-- * xsl:template match (modes) section                                  -->
<!-- ********************************************************************* -->

<!-- * Output the MIME magic into a file MIME magic database, by           -->
<!-- * processing every mime-type element with magic pattern, sorted after -->
<!-- * (first) descending priority (then) ascending alphabetical type      -->
<!-- * order.                                                              -->
<xsl:template match="/">
	<xsl:call-template name="common.write.chunk">
		<xsl:with-param name="filename" select="$file.magic.name"/>
		<xsl:with-param name="method" select="'text'"/>
		<xsl:with-param name="media-type" select="'text/plain'"/>
		<xsl:with-param name="content">
			<xsl:call-template name="common.header.text"/>
			<xsl:call-template name="file.specific.header.text"/>
			<xsl:apply-templates select=".//fdo:mime-type[child::fdo:magic]">
				<xsl:sort select="fdo:magic/@priority" order="descending" data-type="number"/>
				<xsl:sort select="@type"/>
			</xsl:apply-templates>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<!-- * If a magic element is found, check for which system we want to      -->
<!-- * build the database and apply all the match elements depending on    -->
<!-- * the system (with copying the MIME type too).                        -->
<xsl:template match="fdo:magic">
	<xsl:variable name="magic.mime.type" select="ancestor::fdo:mime-type/@type"/>
	
	<xsl:apply-templates select="fdo:match" mode="file">
		<xsl:with-param name="match.mime.type" select="$magic.mime.type"/>
	</xsl:apply-templates>
</xsl:template>

<!-- * file(1)'s mime.magic database uses a format, described in magic(5). -->
<!-- * The problem(s) with the format/syntax:                              -->
<!-- *   - Offset-ranges need to be tranformed, because there is no        -->
<!-- *     similar Offset_start:Offset_end syntax in magic(5) format.      -->
<!-- *   - The value-types differ between the freedesktop.org and the      -->
<!-- *     magic(5) format, so they need to be transformed.                -->
<!-- *   - Search-strings are limited to 31 characters. Strings longer     -->
<!-- *     than 31 chars (which is possible in the fd.o database format),  -->
<!-- *     should be automatically split.                                  -->
<!-- *   - Several string-characters, like spaces or 'greater/less than',  -->
<!-- *     need to be escaped for the database.                            -->
<!-- *   - Pattern test continuation ('>') must be implemented for         -->
<!-- *     (a) each <match> level and (b) for every string-split.          --> 
<xsl:template match="fdo:match" mode="file">
  <!-- * The 'match.level.symbol' parameter holds the string for the test  -->
  <!-- * pattern continuation. After every run, it is encreased with at    -->
  <!-- * least one '>'.                                                    -->
	<xsl:param name="match.level.symbol" select="''"/>
	<xsl:param name="match.mime.type" select="ancestor::fdo:mime-type/@type"/>

	<xsl:choose>
    <!-- * If the type is masked 'string', we do nothing, as file cannot   -->
    <!-- * handle this (but freedesktop.org can). If you want to implement -->
    <!-- * a better solution, send me a patch.                             -->
		<xsl:when test="not(@type = 'string' and @mask)">
      <!-- * Offset values of the kind 'Offset_start:Offset_end' cannot be -->
      <!-- * used. Here we extract the starting offset.                    -->
			<xsl:variable name="adjusted.offset">
				<xsl:choose>
					<xsl:when test="contains(@offset,':')">
						<xsl:value-of select="substring-before(@offset,':')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@offset"/>
					</xsl:otherwise>
				</xsl:choose>	
			</xsl:variable>
      <!-- * In general, the freedesktop.org and the file/KMimeMagic MIME  -->
      <!-- * magic database use different type values. All types except    -->
      <!-- * byte and string need to be transformed with the substitution  -->
      <!-- * values in the 'type.string.subst.map' map.                    -->
      <!-- * There is one special case: If we have an offset value of the  -->
      <!-- * type 'Offset_start:Offset_end' and a type 'string', then the  -->
      <!-- * type needs to be transformed to the literal search type       -->
      <!-- * 'search/{Offset_difference}', while the offset was already    -->
      <!-- * transformed a step earlier.                                   -->
			<xsl:variable name="adjusted.type">
				<xsl:choose>
					<xsl:when test="@type = 'string' and contains(@offset,':')">
						<xsl:value-of select="concat('search','/',substring-after(@offset,':') - substring-before(@offset,':'))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="common.string.subst.apply.map">
							<xsl:with-param name="self.content" select="@type"/>
							<xsl:with-param name="map.contents" select="exsl:node-set($type.string.subst.map)/*"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
      <!-- * String can contain spaces or greater/less than characters.    -->
      <!-- * They need to be escaped with a backslash '\'. It's enough to  -->
      <!-- * only process the first 31 characters of a string, because all -->
      <!-- * other are processed later.                                    -->
			<xsl:variable name="adjusted.value">
				<xsl:choose>
					<xsl:when test="@type = 'string'">
						<xsl:call-template name="common.string.subst.apply.map">
							<xsl:with-param name="self.content" select="substring(@value,0,31)"/>
							<xsl:with-param name="map.contents" select="exsl:node-set($value.string.subst.map)/*"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@value"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

      <!-- * Output the syntax. A typical one could be:                    -->
      <!-- *                                                               -->
      <!-- * 0       string  VjCD0100                                      -->
      <!-- * >8      lelong  0x01020304                                    -->
      <!-- * >>12    lelong  0x00000000                                    -->
      <!-- * >>>16   lelong  0x00000000                                    -->
      <!-- * >>>>20  lelong  0x80000000      chemical/x-cdx                -->
      <!-- * >>>>20  lelong  0x00000000      chemical/x-cdx                -->
      <!-- *                                                               -->
      <!-- * 0       string  CACTVS\ QSAR\ Table   chemical/x-cactvs-table -->
      <!-- *                                                               -->
      <!-- * Every line starts with the initial offset or the continuation -->
      <!-- * string followed by the offset. The second column contains the -->
      <!-- * type; the third contains the value and the fourth (if any),   -->
      <!-- * the MIME type.                                                -->
			<xsl:value-of select="$match.level.symbol"/>
			<xsl:value-of select="$adjusted.offset"/>
			<xsl:text>	</xsl:text>
			<xsl:value-of select="$adjusted.type"/>
			<xsl:if test="@type != 'string'
				            and @mask">
				<xsl:value-of select="concat('&amp;',@mask)"/>
			</xsl:if>
			<xsl:text>	</xsl:text>
		  <xsl:value-of select="$adjusted.value"/>
      <!-- * Now if the string is longer than 31 characeters, we need to   -->
      <!-- * split it and process the rest separated in the template       -->
      <!-- * 'split.string.match'.                                         -->
			<xsl:if test="@type = 'string'
			              and string-length(@value) &gt; 31">
				<xsl:call-template name="split.string.match">
					<xsl:with-param name="string.content" select="substring(@value,31)"/>
					<xsl:with-param name="match.level.symbol" select="concat($match.level.symbol,'&gt;')"/>
				</xsl:call-template>
			</xsl:if>

			<xsl:choose>
        <!-- * And if that's the last pattern test, output the MIME type   -->
        <!-- * followed by a linebreak.                                    -->
				<xsl:when test="not(child::fdo:match[not(@type = 'string' and @mask)])">
					<xsl:text>	</xsl:text>
					<xsl:value-of select="$match.mime.type"/>
					<xsl:text>&#10;</xsl:text>
				</xsl:when>
        <!-- * If that's not the last pattern test, we need to process the -->
        <!-- * child tests too and increase the continuation level.        -->
				<xsl:otherwise>
          <!-- * First of all, add the line-break.                         -->
					<xsl:text>&#10;</xsl:text>
          <!-- * If we had a string longer than 31 characeters, the test   -->
          <!-- * continuation level is now much higher (at least + '>')    -->
          <!-- * then what's in '$match.level.symbol'. So we need to get   -->
          <!-- * the real current continuation level and call              -->
          <!-- * 'add.match.level.support' to get the string to add to the -->
          <!-- * current level. Otherwise add one level up ('>') only.     -->
					<xsl:variable name="match.level.symbol.add">
						<xsl:choose>
							<xsl:when test="@type = 'string'">
								<xsl:call-template name="add.match.level.support">
									<xsl:with-param name="string.content" select="@value"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'&gt;'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
          <!-- * Now process all match children and increase the           -->
          <!-- * continutaion level with the earlier computed level value. -->
					<xsl:apply-templates select="fdo:match" mode="file">
						<xsl:with-param name="match.level.symbol"
						                select="concat($match.level.symbol,$match.level.symbol.add)"/>
						<xsl:with-param name="match.mime.type" select="$match.mime.type"/>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
    <!-- * If we have a match line to ignore, then look into the next      -->
    <!-- * level. Maybe there we have a match element to process.          -->
		<xsl:otherwise>
			<xsl:apply-templates select="fdo:match" mode="file">
				<xsl:with-param name="match.level.symbol" select="$match.level.symbol"/>
				<xsl:with-param name="match.mime.type" select="$match.mime.type"/>
			</xsl:apply-templates>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- * If found a mime-type element, output the MIME type name as a        -->
<!-- * comment before any pattern rule. Then process the rules.            --> 
<xsl:template match="fdo:mime-type">
	<xsl:variable name="mime.type" select="@type"/>
	
	<xsl:text># </xsl:text>
	<xsl:value-of select="$mime.type"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="fdo:magic/@priority"/>
	<xsl:text>&#10;</xsl:text>
	<xsl:apply-templates select="fdo:magic">
		<xsl:with-param name="mime.type" select="$mime.type"/>
	</xsl:apply-templates>
	<xsl:text>&#10;</xsl:text>
</xsl:template>

<!-- * These elements son't need to be processed.                          -->
<xsl:template match="*"/>

<!-- ********************************************************************* -->
<!-- * Named templates for special processing and functions.               -->
<!-- ********************************************************************* -->

<!-- * If we have string values with more than 31 characeters, we need to  -->
<!-- * split them into pieces of 31 chars at maximum. The problem here: If -->
<!-- * we search for a string in an offset range, we've used               -->
<!-- * 'search/Offset_diff string $string_splitpart1' in the 'match'       -->
<!-- * matching template. Now we don't know, where the last offset of the  -->
<!-- * string hit is. Now we need to make sure, that the next part         -->
<!-- * '$string_splitpart2' of the original string directly begins, where  -->
<!-- * the first string '$string_splitpart1' found ends. To realize this,  -->
<!-- * we use the relative offset '&0', that points to the last offset of  -->
<!-- * the preceding rule (hit). A rule would look like this:              -->
<!-- *                                                                     -->
<!-- * >>x     string  $string_splitpart1  #(done earlier)                 -->
<!-- * >>>&0   string  $string_splitpart2  #(done here)                    -->
<!-- * >>>>&0  string  $string_splitpart3  #(done here)                    -->
<!-- *                                                                     -->
<!-- * This exactly fits a search for a string concatenated of all split   -->
<!-- * parts.                                                              -->
<xsl:template name="split.string.match">
	<xsl:param name="string.content"/>
	<xsl:param name="match.level.symbol"/>
	
	<xsl:text>&#10;</xsl:text>
	<xsl:value-of select="$match.level.symbol"/>
  <!-- * Output the relative offset '&0'.                                  -->
	<xsl:text>&amp;0</xsl:text>
	<xsl:text>	</xsl:text>
  <!-- * We search a string.                                               -->
	<xsl:text>string</xsl:text>
	<xsl:text>	</xsl:text>
  <!-- * Output the escaped first 31 characeters of the string ...         -->
	<xsl:call-template name="common.string.subst.apply.map">
		<xsl:with-param name="self.content" select="substring($string.content,0,31)"/>
		<xsl:with-param name="map.contents" select="exsl:node-set($value.string.subst.map)/*"/>
	</xsl:call-template>
	<!-- * ... and call the template itself again with the rest of the       -->
	<!-- * string, starting after characeter 31.                             -->
	<xsl:if test="string-length($string.content) &gt; 31">
		<xsl:call-template name="split.string.match">
			<xsl:with-param name="string.content" select="substring($string.content,31)"/>
			<xsl:with-param name="match.level.symbol" select="concat($match.level.symbol,'&gt;')"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<!-- * This template does almost the same as 'split.string.match', except  -->
<!-- * that we don't output any string-parts. Only the continuation level  -->
<!-- * symbols are output (one per split part).                            -->
<xsl:template name="add.match.level.support">
	<xsl:param name="string.content"/>
	
	<xsl:value-of select="'&gt;'"/>
	<xsl:if test="string-length($string.content) &gt; 31">
		<xsl:call-template name="add.match.level.support">
			<xsl:with-param name="string.content" select="substring($string.content,32)"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<!-- * This template only outputs a header for every possible MIME mgaic   -->
<!-- * pattern database with instructions, how to use it.                  -->
<xsl:template name="file.specific.header.text">
	<xsl:text># This file was created automatically by cmd_file-magic.xsl.        &#10;</xsl:text>
	<xsl:text># Copy or append its content to file(1)'s MIME magic database (on      &#10;</xsl:text>
	<xsl:text># Debian systems, it's the file /etc/magic.mime.                       &#10;</xsl:text>
	<xsl:text>&#10;&#10;</xsl:text>
</xsl:template>

</xsl:stylesheet>
