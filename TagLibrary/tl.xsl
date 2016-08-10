<?xml version="1.0" encoding="iso-8859-1"?>

<!DOCTYPE xsl:stylesheet>

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/REC-html40"
	xmlns:saxon="http://icl.com/saxon"
	extension-element-prefixes="saxon"
	version="1.1">

<xsl:output method="html" indent="yes" encoding="iso-8859-1"/>

<xsl:include href="tl_adds.xsl"/>

<xsl:strip-space elements="*"/>

<xsl:variable name='forecolor'>
	<xsl:text>#116480</xsl:text>
</xsl:variable>

<xsl:variable name='lower'>
	<xsl:text>abcdefghijklmnopqrstuvwxyz</xsl:text>
</xsl:variable>
<xsl:variable name='upper'>
	<xsl:text>ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:text>
</xsl:variable>

<xsl:variable name="borderon">0</xsl:variable>

<xsl:variable name='pubstatus'>
	<xsl:text>release</xsl:text> <!-- change to dev when on pc -->
</xsl:variable>

<xsl:variable name='location'>
	<xsl:choose>
		<xsl:when test='$pubstatus="dev"'>
			<xsl:text>file:/c:/eac/documents/</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>file:/usr/local/tomcat/webapps/saxon/eac/documents/</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>


<xsl:template name="tableattrs">
	<xsl:attribute name='border'>
		<xsl:value-of select="$borderon"/>
	</xsl:attribute>
	<xsl:attribute name="cellspacing">0</xsl:attribute>
	<xsl:attribute name="cellpadding">0</xsl:attribute>
</xsl:template>

<xsl:template match="/">
	<html>
		<head>
			<style>
				<xsl:text>h1, h2, h3, h4, h5, h6</xsl:text>
				<xsl:text>{font-family: arial; color:</xsl:text>
					<xsl:value-of select='$forecolor'/>
				<xsl:text>}</xsl:text>
				<xsl:text>body {</xsl:text>
				<xsl:text>background-color:#FCF4E0;margin-top:0.50in;margin-left:1.0in;margin-right:1.0in;margin-bottom:0.50in;</xsl:text>
				<xsl:text>font-family: arial</xsl:text>
				<xsl:text>}</xsl:text>
			</style>
		</head>
		<body>
			<xsl:apply-templates select='//revisionDesc'/>
			<xsl:apply-templates select='TEI.2/text/front'/>
			<xsl:apply-templates select='TEI.2/text/body' mode='toc'/>
			<xsl:apply-templates select='TEI.2/text/body'/>
		</body>
	</html>
</xsl:template>

<xsl:template match='div1[@type="overview"]'>
	<div id="{@id}">
		<xsl:for-each select='*'>
			<xsl:choose>
				<xsl:when test='self::div2'>
					<xsl:apply-templates mode='ov' select='.'/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select='.'/>
				</xsl:otherwise>
			</xsl:choose>		
		</xsl:for-each>
		<hr/>
	</div>
</xsl:template>

<xsl:template mode='ov' match='div2[@type="overview"] | div3[@type="overview"]'>
	<div id="{@id}">
		<xsl:for-each select='*'>
			<xsl:choose>
				<xsl:when test='self::div3 | self::div4'>
					<xsl:apply-templates mode='ov' select='.'/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select='.'/>
				</xsl:otherwise>
			</xsl:choose>		
		</xsl:for-each>
	</div>
</xsl:template>

<xsl:template match='div2[@type="overview"]/head | div3[@type="overview"]/head'>
	<h3>
		<xsl:apply-templates/>
	</h3>
</xsl:template>

<xsl:template match='titlePage'>
	<div style='text-align:center'>
		<hr/>
		<xsl:apply-templates/>
		<xsl:call-template name='tocref'/>
		<hr/>
	</div>
</xsl:template>

<xsl:template match='titlePart'>
			<h2>
				<xsl:apply-templates/>
			</h2>
</xsl:template>

<xsl:template match='docEdition'>
	<h4>
		<xsl:apply-templates/>
	</h4>
</xsl:template>

<xsl:template match='byline'>
	<h4>
		<br/><br/><br/>
		<xsl:apply-templates/>
	</h4>
</xsl:template>

<xsl:template match='docAuthor'>
	<h4>
		<xsl:apply-templates/>
	</h4>
</xsl:template>

<xsl:template match='docImprint'>
	<br/><br/><br/>
	<h4>
		<xsl:for-each select='* | text()'>
			<xsl:value-of select='.'/>
			<br/>
		</xsl:for-each>
		</h4>
</xsl:template>

<!-- table of contents -->

<xsl:template match='body' mode='toc'>
	<div>
		<a name='toc'/>
		<hr/>
		<h2>Table of Contents</h2>
		<xsl:for-each select='div1/head'>
			<h3>
				<xsl:call-template name='toclink'/>
			</h3>
			<p style='margin-left:12pt'>
				<!-- elements -->
				<xsl:for-each select='parent::div1/div2[@type="element"]/head/gi'>
					<xsl:choose>
						<xsl:when test='substring(.,1,1) = 
	  	        substring(ancestor::div2/preceding-sibling::div2[1]/head/gi,1,1)'>
							<xsl:call-template name='toclink'/>
						</xsl:when>
						<xsl:when test='not(substring(.,1,1) = 
	    	      substring(ancestor::div2/preceding-sibling::div2[1]/head/gi,1,1)) 
							and substring(.,1,1)="a"'>
							<span style='font-size:100%;font-family: arial;color:{$forecolor}'>
								<xsl:value-of select='translate(substring(.,1,1), $lower, $upper)'/>
								<xsl:text>. </xsl:text>	
							</span>
							<xsl:call-template name='toclink'/>
						</xsl:when>
						<xsl:otherwise>
							<br/><br/>
							<span style='font-size:100%;font-family: arial;color:{$forecolor}'>
								<xsl:value-of select='translate(substring(.,1,1), $lower, $upper)'/>
								<xsl:text>. </xsl:text>	
							</span>
							<xsl:call-template name='toclink'/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text> &#160;&#160;</xsl:text>
				</xsl:for-each>
				<!-- attributes -->
				<xsl:for-each select='parent::div1/div2[@type="attribute"]/head'>
					<xsl:choose>
						<xsl:when test='substring(.,1,1) = 
 	      	   substring(ancestor::div2/preceding-sibling::div2[1]/head,1,1)'>
							<xsl:call-template name='attrtoclink'/>
						</xsl:when>
						<xsl:when test='not(substring(.,1,1) = 
   		       substring(ancestor::div2/preceding-sibling::div2[1]/head,1,1)) 
							and substring(.,1,1)="a"'>
							<span style='font-size:100%;font-family: arial;color:{$forecolor}'>
								<xsl:value-of select='translate(substring(.,1,1), $lower, $upper)'/>
								<xsl:text>. </xsl:text>	
							</span>
							<xsl:call-template name='attrtoclink'/>
						</xsl:when>
						<xsl:otherwise>
							<br/><br/>
							<span style='font-size:100%;font-family: arial;color:{$forecolor}'>
								<xsl:value-of select='translate(substring(.,1,1), $lower, $upper)'/>
								<xsl:text>. </xsl:text>	
							</span>
							<xsl:call-template name='attrtoclink'/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text> &#160;&#160;</xsl:text>
				</xsl:for-each>
			</p>
		</xsl:for-each>
	</div>
</xsl:template>

<xsl:template name='toclink'>
	<a style='font-family: arial;color:{$forecolor}'>
		<xsl:attribute name='href'>
			<xsl:text>#</xsl:text>   
			<xsl:choose>
				<xsl:when test='self::gi'>
					<xsl:value-of select='ancestor::div2/@id'/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select='parent::div1/@id'/>
				</xsl:otherwise>
			</xsl:choose>	    	
		</xsl:attribute>
		<xsl:apply-templates/>
	</a>
</xsl:template>

<xsl:template name='attrtoclink'>
	<a style='font-family: arial;color:{$forecolor}'>
		<xsl:attribute name='href'>
			<xsl:text>#</xsl:text>
			<xsl:value-of select='parent::div2/@id'/>
		</xsl:attribute>
		<xsl:value-of select='substring-before(., " ")'/>
	</a>
</xsl:template>

<xsl:template name='tocref'>
		<p style='text-align:center'>
		<a style='font-size:xx-small;text-decoration:none;font-family:arial;color:white;background-color:{$forecolor}' href='#toc'>&#160;TABLE OF CONTENTS&#160;</a>
	</p>
</xsl:template>

<!-- body of text -->

<xsl:template match='body'>
	<hr/>
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match='div1'>
	<div id="{@id}">
		<xsl:apply-templates/>
		<hr/>
	</div>
</xsl:template>

<xsl:template match='div2'>
	<div id="{@id}">
		<xsl:apply-templates/>
		<xsl:call-template name='tocref'/>
		<hr/>
	</div>
</xsl:template>

<xsl:template match='div1/head'>
	<h2>
		<xsl:apply-templates/>
	</h2>
</xsl:template>




<xsl:template match='div2[@type="element"]/head'>
	<h3>
		<xsl:apply-templates/>
	</h3>
</xsl:template>

<xsl:template match='div2[@type="attribute"]/head'>
	<h3>
		<xsl:text>@</xsl:text>
		<xsl:apply-templates/>
	</h3>
</xsl:template>

<xsl:template match='p'>
	<p>
		<xsl:apply-templates/>
	</p>
</xsl:template>

<xsl:template match='p[@xml:space]'>
	<pre>
		<xsl:apply-templates/>
	</pre>
</xsl:template>

<xsl:template match='xref'>
	<a style='font-family: arial;color:{$forecolor}'>
		<xsl:attribute name='href'>
		<xsl:choose>
			<xsl:when test='@type="email"'>
				<xsl:text>mailto:</xsl:text>
				<xsl:value-of select='substring-after (unparsed-entity-uri(@doc), $location)'/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select='unparsed-entity-uri(@doc)'/>
			</xsl:otherwise>
		</xsl:choose>			
		</xsl:attribute>
		<xsl:apply-templates/>
	</a>	
</xsl:template>


<xsl:template match='ref'>
	<a style='font-family: arial;color:{$forecolor}' href="#{@target}">
		<xsl:apply-templates/>
	</a>
</xsl:template>

<xsl:template match='hi'>
	<span style='{@rend}'>
		<xsl:apply-templates/>
	</span>
</xsl:template>

<xsl:template match='list[@type="simple"]'>
	<xsl:variable name='mytest' select='following-sibling::text()'/>
	<xsl:if test='parent::p'>
		<br/>
	</xsl:if>
	<table style="margin-left:6pt">
		<xsl:call-template name='tableattrs'/>
		<xsl:for-each select='item'>
			<xsl:if test='ancestor::div1[@type="overview"]'>
				<tr><td>&#160;</td></tr>
			</xsl:if>
			<tr>
				<xsl:if test='parent::*[@rend="bullet"]'>
					<td>
						<xsl:attribute name="valign">top</xsl:attribute>
						&#x2022;&#160;&#160;
					</td>		
				</xsl:if>
				<td>
					<xsl:attribute name="valign">top</xsl:attribute>
					<xsl:apply-templates/>
				</td>
			</tr>
		</xsl:for-each>
	</table>
<!-- I did this because an if test would not yield a yes for following-sibling::text() -->
	<xsl:if test='string-length($mytest) &gt; 0'>
		<br/>
	</xsl:if>
</xsl:template>

<xsl:template match='list[@type="deflist"]'>
	<xsl:if test='parent::p'>
		<br/><br/>
	</xsl:if>
	<table>
		<xsl:call-template name='tableattrs'/>
		<xsl:if test='parent::p'>
			<xsl:attribute name='style'>margin-left:24pt</xsl:attribute>
		</xsl:if>
		<xsl:for-each select='head'>
			<tr>
				<td>
					<b>
						<xsl:apply-templates/><br/><br/>
					</b>
				</td>
			</tr>
		</xsl:for-each>
		<xsl:for-each select='label'>
			<tr>
				<td>
					<xsl:attribute name="valign">top</xsl:attribute>
					<xsl:apply-templates/>
					<xsl:text>:&#160;&#160;</xsl:text>
				</td>		
				<td>
					<xsl:attribute name="valign">top</xsl:attribute>
					<xsl:apply-templates select='following-sibling::item[1]'/>
				</td>
			</tr>
		</xsl:for-each>
	</table>
</xsl:template>

<!--xsl:template match='list'>
	<table>
		<xsl:for-each select='head'>
			<tr>
				<th>
					<xsl:apply-templates/>
				</th>
			</tr>
		</xsl:for-each>
		<xsl:for-each select='label[following-sibling::item]'>
			<tr>
				<td>
					<xsl:value-of select='.'/>
				</td>
				<td>
					<xsl:value-of select='following-sibling::item'/>
				</td>
			</tr>
		</xsl:for-each>
	</table>
</xsl:template-->

<xsl:template match='gi'>
		<a>
			<xsl:attribute name='name'>
				<xsl:value-of select='generate-id()'/>
			</xsl:attribute>
			<xsl:text>&lt;</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>&gt;</xsl:text>
		</a>
</xsl:template>


<xsl:template match='lb'>
	<xsl:choose>
		<xsl:when test='preceding-sibling::gi[1]'>
			<br/><xsl:text>&#160;&#160;&#160;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<br/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>