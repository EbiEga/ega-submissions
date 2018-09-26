<?xml version="1.0"?>
<!--
This XML file defines mapping rules for converting an Excel worksheet or TSV file to an XML document
Conceptually speaking, the Excel worksheet or TSV file is parsed first into an intermediate XML
document that contains field names as tags and field values as texts. This intermediate XML document
is then transformed into final XML document through XSLT transformation.
You could define multiple templates here, each catering for different schema.
Please note that because XML tag must start with a letter or underscore and contains only
letters, digits, hyphens, underscores and periods, any violating characters should be replaced
with underscores.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:exsl="http://exslt.org/common"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="exsl date">
<xsl:output method="xml" indent="yes"/>

<xsl:template name="parseDelimitedString">
  <xsl:param name="str"/>
  <xsl:param name="delimiter" select="','"/>
  <xsl:variable name="_delimiter">
    <xsl:choose>
      <xsl:when test="string-length($delimiter)=0">,</xsl:when>
      <xsl:otherwise><xsl:value-of select="$delimiter"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="_str">
    <xsl:choose>
      <xsl:when test="contains($str, $delimiter)">
        <xsl:value-of select="normalize-space($str)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(normalize-space($str), $_delimiter)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="first" select="substring-before($_str, $_delimiter)" />
  <xsl:variable name="remaining" select="substring-after($_str, $_delimiter)" />
  <item><xsl:value-of select="$first" /></item>
  <xsl:if test="$remaining!=''">
    <xsl:call-template name="parseDelimitedString">
      <xsl:with-param name="str" select="$remaining" />
      <xsl:with-param name="delimiter" select="$_delimiter" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- EGA DAC -->
<xsl:template match="DACSet">
  <DAC_SET xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:noNamespaceSchemaLocation="ftp://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/EGA.dac.xsd">
    <xsl:for-each select="DAC">
      <DAC>
        <xsl:if test="DAC_ID!=''">
          <xsl:attribute name="accession"><xsl:value-of select="DAC_ID"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="DAC_alias!=''">
          <xsl:attribute name="alias"><xsl:value-of select="DAC_alias"/></xsl:attribute>
        </xsl:if>
        <xsl:attribute name="broker_name">EGA</xsl:attribute>
        <xsl:variable name="dac_id"><xsl:value-of select="DAC_ID"/></xsl:variable>
        <xsl:variable name="dac_alias"><xsl:value-of select="DAC_alias"/></xsl:variable>
        <TITLE><xsl:value-of select="Title"/></TITLE>
        <CONTACTS>
          <xsl:for-each select="/ResultSet/ContactSet/Contact[DAC_ID=$dac_id or DAC_alias=$dac_alias]">
            <CONTACT>
              <xsl:attribute name="name"><xsl:value-of select="concat(Name, ' ', Surname)"/></xsl:attribute>
              <xsl:attribute name="email"><xsl:value-of select="Email"/></xsl:attribute>
              <xsl:attribute name="telephone_number"><xsl:value-of select="Telephone_number"/></xsl:attribute>
              <xsl:if test="Middle_initials!=''">
                <xsl:attribute name="middle_initials"><xsl:value-of select="Middle_initials"/></xsl:attribute>
              </xsl:if>
              <xsl:if test="Organisation!=''">
                <xsl:attribute name="organisation"><xsl:value-of select="Organisation"/></xsl:attribute>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="Main_contact=0">
                  <xsl:attribute name="main_contact">false</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="main_contact">true</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="Organisation!=''">
                <xsl:attribute name="organisation"><xsl:value-of select="Organisation"/></xsl:attribute>
              </xsl:if>
            </CONTACT>
          </xsl:for-each>
        </CONTACTS>
        <xsl:if test="DAC_links!=''">
          <DAC_LINKS>
            <xsl:variable name="itemsProxy">
              <xsl:call-template name="parseDelimitedString">
                <xsl:with-param name="str" select="DAC_links" />
                <xsl:with-param name="delimiter" select="','" />
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="items" select="exsl:node-set($itemsProxy)" />
            <xsl:for-each select="$items/item">
              <DAC_LINK>
                <URL_LINK>
                  <URL><xsl:value-of select="."/></URL>
                  <LABEL>EGA web</LABEL>
                </URL_LINK>
              </DAC_LINK>
            </xsl:for-each>
          </DAC_LINKS>
        </xsl:if>
        <DAC_ATTRIBUTES>
          <xsl:for-each select="/ResultSet/ContactSet/Contact[DAC_ID=$dac_id or DAC_alias=$dac_alias]">
            <DAC_ATTRIBUTE>
              <TAG><xsl:value-of select="concat(Email, ':', title)"/></TAG>
              <VALUE><xsl:value-of select="Title"/></VALUE>
            </DAC_ATTRIBUTE>
            <DAC_ATTRIBUTE>
              <TAG><xsl:value-of select="concat(Email, ':', address)"/></TAG>
              <VALUE><xsl:value-of select="Address"/></VALUE>
            </DAC_ATTRIBUTE>
          </xsl:for-each>
        </DAC_ATTRIBUTES>
      </DAC>
    </xsl:for-each>
  </DAC_SET>
</xsl:template>

<!-- EGA Policy -->
<xsl:template match="PolicySet">
  <POLICY_SET xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:noNamespaceSchemaLocation="ftp://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/EGA.policy.xsd">
    <xsl:for-each select="Policy">
      <POLICY>
        <xsl:if test="Policy_ID!=''">
          <xsl:attribute name="accession"><xsl:value-of select="Policy_ID"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="Policy_alias!=''">
          <xsl:attribute name="alias"><xsl:value-of select="Policy_alias"/></xsl:attribute>
        </xsl:if>
        <xsl:attribute name="broker_name">EGA</xsl:attribute>
        <xsl:variable name="policy_id"><xsl:value-of select="Policy_ID"/></xsl:variable>
        <xsl:variable name="policy_alias"><xsl:value-of select="Policy_alias"/></xsl:variable>
        <TITLE><xsl:value-of select="Title"/></TITLE>
        <DAC_REF>
          <xsl:if test="DAC_ID!=''">
            <xsl:attribute name="accession"><xsl:value-of select="DAC_ID"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="DAC_alias!=''">
            <xsl:attribute name="alias"><xsl:value-of select="DAC_alias"/></xsl:attribute>
          </xsl:if>
        </DAC_REF>
        <xsl:choose>
          <xsl:when test="Policy_file!=''">
            <POLICY_FILE><xsl:value-of select="Policy_file"/></POLICY_FILE>
          </xsl:when>
          <xsl:otherwise>
            <POLICY_TEXT><xsl:value-of select="Policy_text"/></POLICY_TEXT>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="count(/ResultSet/DUOSet/DUO[Policy_ID=$policy_id or Policy_alias=$policy_alias])>0">
          <DATA_USES>
            <xsl:for-each select="/ResultSet/DUOSet/DUO[Policy_ID=$policy_id or Policy_alias=$policy_alias]">
              <DATA_USE>
                <xsl:attribute name="ontology"><xsl:value-of select="DB"/></xsl:attribute>
                <xsl:attribute name="code"><xsl:value-of select="ID"/></xsl:attribute>
                <xsl:choose>
                  <xsl:when test="Version!=''">
                    <xsl:attribute name="version"><xsl:value-of select="Version"/></xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="version">
                      <xsl:value-of select="substring(date:date(), 1, 10)"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="Modifiers!=''">
                  <xsl:variable name="modifiersProxy">
                    <xsl:call-template name="parseDelimitedString">
                      <xsl:with-param name="str" select="Modifiers" />
                      <xsl:with-param name="delimiter" select="','" />
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:variable name="modifiers" select="exsl:node-set($modifiersProxy)" />
                  <xsl:for-each select="$modifiers/item">
                    <MODIFIER>
                      <xsl:variable name="modifierProxy">
                        <xsl:call-template name="parseDelimitedString">
                          <xsl:with-param name="str" select="." />
                          <xsl:with-param name="delimiter" select="':'" />
                        </xsl:call-template>
                      </xsl:variable>
                      <xsl:variable name="modifier" select="exsl:node-set($modifierProxy)" />
                      <DB><xsl:value-of select="$modifier/item[1]"/></DB>
                      <ID><xsl:value-of select="$modifier/item[2]"/></ID>
                    </MODIFIER>
                  </xsl:for-each>
                </xsl:if>
                <xsl:if test="URL!=''">
                  <URL><xsl:value-of select="URL"/></URL>
                </xsl:if>
              </DATA_USE>
            </xsl:for-each>
          </DATA_USES>
        </xsl:if>
        <xsl:if test="Policy_link!=''">
          <POLICY_LINKS>
            <xsl:variable name="policyLinksProxy">
              <xsl:call-template name="parseDelimitedString">
                <xsl:with-param name="str" select="Modifiers" />
                <xsl:with-param name="delimiter" select="';'" />
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="policyLinks" select="exsl:node-set($policyLinksProxy)" />
            <xsl:for-each select="$policyLinks/item">
              <POLICY_LINK>
                <URL_LINK>
                  <URL><xsl:value-of select="."/></URL>
                  <LABEL>EGA web</LABEL>
                </URL_LINK>
              </POLICY_LINK>
            </xsl:for-each>
          </POLICY_LINKS>
        </xsl:if>
      </POLICY>
    </xsl:for-each>
  </POLICY_SET>
</xsl:template>

<xsl:template match="ContactSet"/>

<xsl:template match="DUOSet"/>

</xsl:stylesheet>
