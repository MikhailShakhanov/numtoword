<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="menu">
  <xsl:apply-templates select="menuitem">
    <xsl:with-param name="current" select="3" />
  </xsl:apply-templates>
</xsl:template>
<xsl:template match="menuitem">
  <xsl:param name="current" select="1" />
  <xsl:choose>
    <xsl:when test="$current=@index">
      <b>
        <xsl:value-of select="@name" />
      </b>
    </xsl:when>
    <xsl:otherwise>
      <a href="{@href}">
        <xsl:value-of select="@name" />
      </a>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>

