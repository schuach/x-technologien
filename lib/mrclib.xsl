<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mrclib="https://share.obvsg.at/xml/xsl/mrclib" expand-text="yes" version="3.0">

  <!--~doc:global
      @title mrclib - common operations on MARC21-XML data
  -->
  <!--~doc:stylesheet
      This stylesheet includes functions and templates for common operations on MARC-XML data.

      To keep the footprint small, functions and templates that rely on lookups and therefore
      potentially large data, are found in lookups.xsl

      @title mrclib.xsl
  -->

  <!--
      Create a MARC datafield 005 with a given date and time.

      Defaults to the current date and time.
  -->
  <xsl:template name="mrclib:create005">
    <xsl:param name="dateTime" select="current-dateTime()" as="xs:dateTime" />
    <controlfield tag="005">{$dateTime => format-dateTime("[Y0001][M01][D01][H01][m01][s01].0")}</controlfield>
  </xsl:template>

  <!-- Update or create MARC 041 with a language code from 008.

       - If there is a field `041`, add the language code from 008 as first `$$a`, if it's not already there. Keep the indicators.
       - If there is no field `041`, add one with indicators `##` and the language code from 008 in `$$a`.
  -->
  <xsl:template name="mrclib:create041">
    <xsl:variable name="lang008" select="substring(./controlfield[@tag='008'][1], 36, 3)" />
    <xsl:variable name="lang041a" select="./datafield[@tag='041']/subfield[@code='a']/string()" />
    <xsl:variable name="df041_ind1" select="./datafield[@tag='041']/@ind1" />

    <xsl:choose>
      <xsl:when test="not($lang008 = $lang041a)
                      and not($lang008 = 'mul')
                      and matches($lang008, '[a-z]{3}')">
        <datafield tag="041" ind1="{if ($df041_ind1)
                              then ($df041_ind1)
                              else ' '}" ind2=" ">
          <subfield code="a">{$lang008}</subfield>
          <xsl:for-each select="./datafield[@tag='041']/subfield">
            <xsl:copy-of select="." />
          </xsl:for-each>
        </datafield>
      </xsl:when>
      <xsl:when test="$lang008 = 'mul' and not(./datafield[@tag='041'])">
        <datafield tag="041" ind1=" " ind2=" ">
          <subfield code="a">mul</subfield>
        </datafield>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="./datafield[@tag='041']" />
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!--
      Return a string with non filing characters added. These characters are `<<` for the start
      and `>>` for the end of the non filing portion of the string.

      So `mrclib:nonFilingChars('The Order of Entries', 3)` returns the string `<<The>> Order of Entries`

      @param subfield the subfield to be processed
      @param charCount the number of non filing characters, the second indicator of MARC `245` most of the time.
      @return The input string with non filing characters added.
  -->
  <xsl:function name="mrclib:nonFilingChars" as="xs:string">
    <xsl:param name="subfield" />
    <xsl:param name="charCount" />
    <xsl:variable name='offset'>
      <xsl:choose>
        <xsl:when test="not(number($charCount))">0</xsl:when>
        <xsl:when test="substring($subfield, $charCount, 1) = ' '">{$charCount - 1}</xsl:when>
        <xsl:otherwise>{$charCount}</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$offset != 0">
        <subfield code="{$subfield/@code}">{'&lt;&lt;' || substring($subfield, 1, $offset) || '&gt;&gt;' || substring($subfield, $offset + 1)}</subfield>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$subfield" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!--
      Remove ISBD-Punctuation at the end of a string

      @param: s the string to be processed
  -->
  <xsl:function name="mrclib:remove-isbd"
                as="xs:string">
    <xsl:param name="s" as="xs:string" />

    <xsl:variable name="isbdChars"
                  select="('.', ',', ':', ';', '/')" />
    <xsl:choose>
      <!-- Account for initials -->
      <xsl:when test="matches($s, '\W[A-Z]\.$')">
        <xsl:value-of select="$s" />
      </xsl:when>
      <xsl:when test="substring($s, string-length($s)) = $isbdChars">
        <xsl:value-of select="substring($s, 1, string-length($s) - 1) => normalize-space()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$s" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>


  <!--
      Replaces characters of a MARC controlfield. Character positions start with 0!

      **!!! ATTENTION !!!!**
      This is just a version of mrclib:replace-substring() with zero-indexing!
      This is to be more in line with MARC-lingo, where character positions
      count from 0.
  -->
  <xsl:function name="mrclib:replace-control-substring"
                as="xs:string">
    <xsl:param name="inputString" as="xs:string" />
    <xsl:param name="start" as="xs:integer" />
    <xsl:param name="end" as="xs:integer" />
    <xsl:param name="replacement" as="xs:string" />

    <xsl:sequence select="mrclib:replace-substring($inputString, $start + 1, $end + 1, $replacement)" />
  </xsl:function>

  <!--
      Replaces the substring from $start to $end (inclusive) of $inputString with $replacement.

      Beware that indices start with 1 in XSLT!

      In case of an error, the original string is returned. Error cases are:
      - $replacement doesn't fit between $start and $end (this is also the case if )
      - $start is less than 1
      - $end is greater than the length of the $inputString
  -->
  <xsl:function name="mrclib:replace-substring"
                as="xs:string">
    <xsl:param name="inputString" as="xs:string" />
    <xsl:param name="start" as="xs:integer" />
    <xsl:param name="end" as="xs:integer" />
    <xsl:param name="replacement" as="xs:string" />
    <xsl:variable name="replacementFits" as="xs:boolean"
               select="$start ge 1
                       and $end le string-length($inputString)
                       and $end - $start + 1 eq string-length($replacement)"/>

    <xsl:choose>
      <xsl:when test="$replacementFits">
        <xsl:sequence
          select="(substring($inputString, 0, $start)
                         || $replacement
                         || substring($inputString, $end + 1))
                    => substring(1, string-length($inputString))" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>Invalid Parameters: replacement doesn't fit into specified substring</xsl:message>
        <xsl:sequence select="$inputString" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>


  <!--
      Template that sorts the subfields of a field according to the order passed as a parameter.
      It returns the field with sorted subfields (not just the subfields themselves).

      The sorting order is passed to the parameter sortSpec as a string of subfield codes.
      The subfields are then sorted in the order in which the codes appear in the string.
      Subfields not included in the string are sorted alphabetically at the end.
      Multiple subfields with the same code retain their relative order.

      ## Example

      ```xml
      <datafield tag="999" ind1=" " ind2=" ">
        <subfield code="0">SF0</subfield>
        <subfield code="a">SFa</subfield>
        <subfield code="b">SFb</subfield>
        <subfield code="c">SFc1</subfield>
        <subfield code="c">SFc2</subfield>
      </datafield>
      ```

      Whenn called with `<xsl:param name='sortSpec' select="'c0'" />`, it becomes

      ```xml
      <datafield tag="999" ind1=" " ind2=" ">
        <subfield code="c">SFc1</subfield>
        <subfield code="c">SFc2</subfield>
        <subfield code="0">SF0</subfield>
        <subfield code="a">SFa</subfield>
        <subfield code="b">SFb</subfield>
      </datafield>
      ```

      @context datafield
  -->
  <xsl:template name="mrclib:sortSubfields">
    <xsl:param name="sortSpec" as="xs:string" required="yes" />
    <xsl:variable name="datafield" select="." />
    <xsl:variable name="subfSequence"
                  select="for $code in string-to-codepoints($sortSpec)
                          return codepoints-to-string($code)" />
    <datafield tag="{@tag}" ind1="{@ind1}" ind2="{@ind2}">
      <xsl:for-each select="$subfSequence">
        <xsl:variable name="code" select="." />
        <xsl:sequence select="$datafield/subfield[@code=$code]" />
      </xsl:for-each>
      <xsl:perform-sort select="$datafield/subfield[not(@code=$subfSequence)]">
        <xsl:sort select="@code" />
      </xsl:perform-sort>
    </datafield>
  </xsl:template>



</xsl:stylesheet>
