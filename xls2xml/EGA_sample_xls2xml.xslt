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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:regexp="http://exslt.org/regular-expressions"
                extension-element-prefixes="regexp">

<xsl:output method="xml" indent="yes"/>

<!--< Sample >-->
<xsl:template match="SampleSet">
  <SAMPLE_SET xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:noNamespaceSchemaLocation="ftp://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/SRA.sample.xsd">
    <xsl:for-each select="Sample">
      <SAMPLE>
        <xsl:if test="Sample_ID!=''">
          <xsl:attribute name="accession"><xsl:value-of select="Sample_ID"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="Sample_alias!=''">
          <xsl:attribute name="alias"><xsl:value-of select="Sample_alias"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="Center_name!=''">
          <xsl:attribute name="center_name"><xsl:value-of select="Center_name"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="Title!=''">
          <TITLE><xsl:value-of select="Title"/></TITLE>
        </xsl:if>
        <SAMPLE_NAME>
          <TAXON_ID><xsl:value-of select="Taxon_id"/></TAXON_ID>
        </SAMPLE_NAME>
        <DESCRIPTION><xsl:value-of select="Description"/></DESCRIPTION>
        <xsl:if test="External_Links!=''">
          <SAMPLE_LINKS>
            <SAMPLE_LINK>
              <XREF_LINK>
                <LABEL>Sample External Link</LABEL>
                <DB><xsl:value-of select="substring-before(External_Links, ':')"/></DB>
                <ID><xsl:value-of select="substring-after(External_Links, ':')"/></ID>
              </XREF_LINK>
            </SAMPLE_LINK>
          </SAMPLE_LINKS>
        </xsl:if>
        <SAMPLE_ATTRIBUTES>
          <xsl:if test="Version!=''">
            <SAMPLE_ATTRIBUTE>
              <TAG>Version</TAG>
              <VALUE><xsl:value-of select="Version"/></VALUE>
            </SAMPLE_ATTRIBUTE>
          </xsl:if>
          <xsl:if test="BioSample_ID!=''">
            <SAMPLE_ATTRIBUTE>
              <TAG>BioSample_ID</TAG>
              <VALUE><xsl:value-of select="BioSample_ID"/></VALUE>
            </SAMPLE_ATTRIBUTE>
          </xsl:if>
          <xsl:if test="NCBI_MD5!=''">
            <SAMPLE_ATTRIBUTE>
              <TAG>NCBI_MD5</TAG>
              <VALUE><xsl:value-of select="NCBI_MD5"/></VALUE>
            </SAMPLE_ATTRIBUTE>
          </xsl:if>
          <SAMPLE_ATTRIBUTE>
            <TAG>gender</TAG>
            <VALUE><xsl:value-of select="Gender"/></VALUE>
          </SAMPLE_ATTRIBUTE>
          <SAMPLE_ATTRIBUTE>
            <TAG>phenotype</TAG>
            <VALUE><xsl:value-of select="Phenotype"/></VALUE>
          </SAMPLE_ATTRIBUTE>
          <xsl:for-each select="*">
            <xsl:if test="regexp:test(name(.), '^Characteristic_-_[a-zA-Z0-9_]*')">
              <xsl:if test=".!=''">
                <SAMPLE_ATTRIBUTE>
                  <TAG>
                    <xsl:value-of select="translate(substring(name(.), string-length('Characteristic_-_')+1),
                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
                  </TAG>
                  <VALUE><xsl:value-of select="."/></VALUE>
                </SAMPLE_ATTRIBUTE>
              </xsl:if>
            </xsl:if>
          </xsl:for-each>
        </SAMPLE_ATTRIBUTES>
      </SAMPLE>
    </xsl:for-each>
  </SAMPLE_SET>
</xsl:template>

</xsl:stylesheet>