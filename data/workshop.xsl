<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utils="https://share.obvsg.at/xml/xsl/utils"
                xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib"
                expand-text="yes"
                exclude-result-prefixes="xs utils mrclib"
                version="3.0">

  <!-- Inkludiere mrclib -->
  <xsl:include href="../lib/mrclib.xsl" />
  <!-- Mode declarations. Knoten ohne Template werden 1:1 in den Output kopiert. -->
  <xsl:mode on-no-match="shallow-copy" />
  <xsl:mode name="sort" on-no-match="shallow-copy" />
  <!-- Rücke den Output ein, damit man ihn besser lesen kann. -->
  <xsl:output indent="yes" />

  <!--
      Dieses Template ist der Einsprungspunkt für die Normalisierung.

      Es matcht aus den MARC-Record und wendet weitere Templates auf die Kind-Elemente an.
      Das Ergebnis wird in eine Variable geschrieben, damit die Felder dann sortiert in den
      resultierenden Datensatz geschrieben werden können.
  -->
  <xsl:template match="record">
    <xsl:variable name="transformedFields" as="item()*">
      <xsl:apply-templates />
    </xsl:variable>
    <record>
      <xsl:apply-templates select="$transformedFields" mode="sort">
        <xsl:sort select="@tag" />
      </xsl:apply-templates>
    </record>
  </xsl:template>

  <!-- Sortiere die Subfelder in 100, 600 und 700 in der Reihenfolge abcd014 -->
  <xsl:template match="datafield[@tag=('100', '600', '700')]" mode="sort">
    <xsl:call-template name="mrclib:sortSubfields">
      <xsl:with-param name="sortSpec" select="'abcd014'" />
    </xsl:call-template>
  </xsl:template>

  <!-- Entferne das Feld mit dem tag "CAT". -->
  <xsl:template match="datafield[@tag='CAT']" />

  <!-- Entferne IMD-Typen. -->
  <xsl:template match="datafield[@tag=('336', '337', '338')]" />

  <!-- Verwandle 500 in 502, wenn SFa "Univ., Diss." enthält. -->
  <xsl:template match="datafield[@tag='500']
                                [subfield[@code='a'][contains(.,
                                'Univ., Diss.')]]">
    <datafield tag="502" ind1="{@ind1}" ind2="{@ind2}">
      <xsl:apply-templates />
    </datafield>
  </xsl:template>

  <!-- Ersetze den Text "Diss." durch "Dissertation". -->
  <xsl:template match="datafield[@tag='500']
                                /subfield[@code='a'][contains(.,
                                'Univ., Diss.')]">
    <subfield code="{@code}">{replace(., "Diss.", "Dissertation")}</subfield>
  </xsl:template>

  <!--
      - Ersetze alle "#" im leader durch " "
      - Setze LDR/19 auf " ", wenn es keine 830 im Datensatz gibt.
  -->
  <xsl:template match="leader">
    <xsl:variable name="isIssue"
                  select="../datafield[@tag='830']" />
    <leader>{
      replace(., "#", " ")
      ! (if (not($isIssue))
         then mrclib:replace-control-substring(., 19, 19, " ")
         else .)
    }</leader>
  </xsl:template>

  <!-- Verschiebe die ORCID aus SF9 mit Präfix "(orcid)" nach SF1 und mache einen URL daraus. -->
  <xsl:template match="datafield[@tag=('100', '600' ,'700')]
                       /subfield[@code='9'][starts-with(., '(orcid)')]">
    <subfield code="1">https://orcid.org/{replace(., '\(orcid\)', '')}</subfield>
  </xsl:template>

  <!--
      Mache aus einer `264` mit mehreren `$$b` je eine `264` pro `$$b`.

      Für jedes `$$b` erzeuge eine `264` mit alles Subfeldern vor dem ersten `$$a`, allen Subfeldern
      nach dem letzen `$$b`, und den `$$a`, die direkt vor dem jeweiligen `$$b` kommen.

      Wenn es `$$6` oder `$$8` gibt, wird das Feld derzeit noch ignoriert. Das liegt daran, dass
      hier auch die korrespondierenden Felder `880` bearbeitet werden müssen. Das ist sehr komplex
      und daher noch nicht implementiert.
      @_marcFields 264
  -->
  <xsl:template match="datafield[@tag='264'][count(subfield[@code='b']) gt 1][not(subfield[@code=('6', '8')])]">
    <xsl:variable name="df264" select="." />
    <xsl:variable name="sfsBeforeAb" select="subfield[not(@code=('a', 'b'))][following-sibling::subfield[@code=('a', 'b')]]" />
    <xsl:variable name="sfsAfterAb" select="subfield[not(@code=('a', 'b'))][preceding-sibling::subfield[@code=('a', 'b')]]" />
    <xsl:for-each-group select="subfield[@code=('a', 'b')]"
                        group-ending-with="subfield[@code='b']
                                           [position() eq last() or following-sibling::subfield[1][@code=('a')]]">
        <xsl:variable name="grp" select="current-group()" as="element(subfield)*" />
      <xsl:choose>
        <xsl:when test="count($grp[@code='b']) lt 2">
          <datafield tag="264" ind1="{$df264/@ind1}" ind2="{$df264/@ind2}">
            <xsl:sequence select="$sfsBeforeAb" />
            <xsl:sequence select="current-group()" />
            <xsl:sequence select="$sfsAfterAb" />
          </datafield>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="$grp[@code='b']">
            <datafield tag="264" ind1="{$df264/@ind1}" ind2="{$df264/@ind2}">
              <xsl:sequence select="$sfsBeforeAb" />
              <xsl:sequence select="$grp[@code='a']" />
              <xsl:sequence select="." />
            <xsl:sequence select="$sfsAfterAb" />
            </datafield>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

</xsl:stylesheet>
