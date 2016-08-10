<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:output method="html" indent="yes" />

<!--
This style sheet contains additions to the tl.xsl made by P-G Ottosson for the working draft of EAC Tabl Library tl.xsl
--> 

<!-- latest update 2002-12-20 -->
<xsl:template match='//revisionDesc'>
<p style="font-size: x-small; color: #543F07" >
	<xsl:for-each select="change">
	<xsl:sort select="date/@value"/>
		<xsl:if test="position()=last()">
			<i><xsl:text>Latest update:  </xsl:text></i>
			<xsl:value-of select="respStmt/name" /> 
			<xsl:text> (</xsl:text>
			<xsl:value-of select="date/@value"/>
			<xsl:text>)</xsl:text>	
		</xsl:if>
	</xsl:for-each>
</p>
</xsl:template>

<!-- display of internal comments 2003-01-02 -->
<xsl:template match="//comment()">
   <p style="font-size: small; color: red" >
	<xsl:text>#   </xsl:text>
   <xsl:value-of select="."/>
	<xsl:text>   #</xsl:text>
  </p>
</xsl:template>


</xsl:stylesheet>