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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

<xsl:output method="xml" indent="yes"/>

<!-- Run -->
<xsl:template match="RunSet">
  <RUN_SET xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:noNamespaceSchemaLocation="ftp://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/SRA.run.xsd">
    <xsl:for-each select="Run">
      <xsl:variable name="file_owner_id">
        <xsl:choose>
          <xsl:when test="Run_ID!=''"><xsl:value-of select="Run_ID"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="Run_alias"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="count(//ResultSet/FileSet/File[File_owner='RUN'][File_owner_ID=$file_owner_id])>0">
        <RUN>
          <xsl:if test="Run_ID!=''">
            <xsl:attribute name="accession"><xsl:value-of select="Run_ID"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="Run_alias!=''">
            <xsl:attribute name="alias"><xsl:value-of select="Run_alias"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="Run_center!=''">
            <xsl:attribute name="center_name"><xsl:value-of select="Run_center"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="Title!=''">
            <TITLE><xsl:value-of select="Title"/></TITLE>
          </xsl:if>
          <EXPERIMENT_REF>
            <xsl:if test="Experiment_ID!=''">
              <xsl:attribute name="refname"><xsl:value-of select="Experiment_ID"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="Run_center!=''">
              <xsl:attribute name="refcenter"><xsl:value-of select="Run_center"/></xsl:attribute>
            </xsl:if>
          </EXPERIMENT_REF>
          <DATA_BLOCK>
            <FILES>
              <xsl:for-each select="/ResultSet/FileSet/File[File_owner='RUN'][File_owner_ID=$file_owner_id]">
                <FILE>
                  <xsl:attribute name="filename">
                    <xsl:value-of select="File_name"/>
                  </xsl:attribute>
                  <xsl:attribute name="filetype">
                    <xsl:value-of select="File_type"/>
                  </xsl:attribute>
                  <xsl:attribute name="checksum_method">
                    <xsl:choose>
                      <xsl:when test="Checksum_method!=''"><xsl:value-of select="Checksum_method"/></xsl:when>
                      <xsl:otherwise><xsl:value-of select="string('MD5')"/></xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  <xsl:attribute name="checksum">
                    <xsl:value-of select="Encrypted_checksum"/>
                  </xsl:attribute>
                  <xsl:if test="Unencrypted_checksum!=''">
                    <xsl:attribute name="unencrypted_checksum">
                      <xsl:value-of select="Unencrypted_checksum"/>
                    </xsl:attribute>
                  </xsl:if>
                </FILE>
              </xsl:for-each>
            </FILES>
          </DATA_BLOCK>
          <xsl:if test="Run_links!=''">
            <RUN_LINKS>
              <RUN_LINK>
                <URL_LINK>
                  <LABEL>Run link</LABEL>
                  <URL><xsl:value-of select="Run_links"/></URL>
                </URL_LINK>
              </RUN_LINK>
            </RUN_LINKS>
          </xsl:if>
        </RUN>
      </xsl:if>
    </xsl:for-each>
  </RUN_SET>
</xsl:template>

<xsl:template match="FileSet"/>

</xsl:stylesheet>