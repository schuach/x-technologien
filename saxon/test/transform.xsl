<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="utf-8"/>
  <xsl:template match="record">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  <xsl:template match="test">
    <xsl:value-of select="."/>
  </xsl:template>
</xsl:stylesheet>
