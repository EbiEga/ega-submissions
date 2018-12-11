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

<!-- Experiment -->
<xsl:template match="ExperimentSet">
  <EXPERIMENT_SET xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:noNamespaceSchemaLocation="ftp://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/SRA.experiment.xsd">
    <xsl:for-each select="Experiment">
      <EXPERIMENT>
        <xsl:variable name="experiment_id">
          <xsl:choose>
            <xsl:when test="Experiment_ID!=''"><xsl:value-of select="Experiment_ID"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="Experiment_alias"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="Experiment_ID!=''">
          <xsl:attribute name="accession"><xsl:value-of select="Experiment_ID"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="Experiment_alias!=''">
          <xsl:attribute name="alias"><xsl:value-of select="Experiment_alias"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="Center_name!=''">
          <xsl:attribute name="center_name"><xsl:value-of select="Center_name"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="Title!=''">
          <TITLE><xsl:value-of select="Title"/></TITLE>
        </xsl:if>
        <STUDY_REF>
          <xsl:attribute name="refname"><xsl:value-of select="Study_ID"/></xsl:attribute>
          <xsl:if test="Center_name!=''">
            <xsl:attribute name="refcenter"><xsl:value-of select="Center_name"/></xsl:attribute>
          </xsl:if>
          <IDENTIFIERS>
            <SUBMITTER_ID>
              <xsl:attribute name="namespace"><xsl:value-of select="Center_name"/></xsl:attribute>
              <xsl:value-of select="Study_ID"/>
            </SUBMITTER_ID>
          </IDENTIFIERS>
        </STUDY_REF>
        <DESIGN>
          <DESIGN_DESCRIPTION><xsl:value-of select="Design_description"/></DESIGN_DESCRIPTION>
          <SAMPLE_DESCRIPTOR>
            <xsl:for-each select="/ResultSet/SampleSet/Sample[Experiment_ID=$experiment_id]">
              <xsl:variable name="sample_refname">
                <xsl:choose>
                  <xsl:when test="Sample_alias!=''"><xsl:value-of select="Sample_alias"/></xsl:when>
                  <xsl:otherwise><xsl:value-of select="Sample_ID"/></xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:attribute name="refname"><xsl:value-of select="$sample_refname"/></xsl:attribute>
              <xsl:if test="Center_name!=''">
                <xsl:attribute name="refcenter"><xsl:value-of select="Center_name"/></xsl:attribute>
              </xsl:if>
            </xsl:for-each>
            <IDENTIFIERS>
              <xsl:for-each select="/ResultSet/SampleSet/Sample[Experiment_ID=$experiment_id]">
                <xsl:choose>
                  <xsl:when test="Sample_ID!=''">
                    <PRIMARY_ID><xsl:value-of select="Sample_ID"/></PRIMARY_ID>
                  </xsl:when>
                  <xsl:otherwise>
                    <SUBMITTER_ID>
                      <xsl:attribute name="namespace"><xsl:value-of select="Center_name"/></xsl:attribute>
                      <xsl:value-of select="Sample_alias"/>
                    </SUBMITTER_ID>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </IDENTIFIERS>

          </SAMPLE_DESCRIPTOR>
          <LIBRARY_DESCRIPTOR>
            <xsl:if test="Library_name!=''">
              <LIBRARY_NAME><xsl:value-of select="Library_name"/></LIBRARY_NAME>
            </xsl:if>
            <LIBRARY_STRATEGY><xsl:value-of select="Library_strategy"/></LIBRARY_STRATEGY>
            <LIBRARY_SOURCE><xsl:value-of select="Library_source"/></LIBRARY_SOURCE>
            <LIBRARY_SELECTION><xsl:value-of select="Library_selection"/></LIBRARY_SELECTION>
            <LIBRARY_LAYOUT>
              <xsl:choose>
                <xsl:when test="Library_layout='SINGLE'"><SINGLE/></xsl:when>
                <xsl:otherwise>
                  <PAIRED>
                    <xsl:if test="Library_nominal_length__insert_size_!=''">
                      <xsl:attribute name="NOMINAL_LENGTH">
                        <xsl:value-of select="Library_nominal_length__insert_size_"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="Library_nominal_length_standard_deviation!=''">
                      <xsl:attribute name="NOMINAL_SDEV">
                        <xsl:value-of select="Library_nominal_length_standard_deviation"/>
                      </xsl:attribute>
                    </xsl:if>
                  </PAIRED>
                </xsl:otherwise>
              </xsl:choose>
            </LIBRARY_LAYOUT>
            <xsl:if test="Library_construction_protocol!=''">
              <LIBRARY_CONSTRUCTION_PROTOCOL>
                <xsl:value-of select="Library_construction_protocol"/>
              </LIBRARY_CONSTRUCTION_PROTOCOL>
            </xsl:if>
          </LIBRARY_DESCRIPTOR>
        </DESIGN>
        <PLATFORM>
          <xsl:variable name="platform"><xsl:value-of select="Platform"/></xsl:variable>
          <xsl:element name="{$platform}">
            <INSTRUMENT_MODEL><xsl:value-of select="Instrument_model"/></INSTRUMENT_MODEL>
          </xsl:element>
        </PLATFORM>
        <xsl:if test="Experiment_links!=''">
          <EXPERIMENT_LINKS>
            <xsl:for-each select="tokenize(.,',')">
              <EXPERIMENT_LINK>
                <URL_LINK>
                  <LABEL>Experiment link</LABEL>
                  <URL><xsl:value-of select="."/></URL>
                </URL_LINK>
              </EXPERIMENT_LINK>
            </xsl:for-each>
          </EXPERIMENT_LINKS>
        </xsl:if>
        </EXPERIMENT>
    </xsl:for-each>
  </EXPERIMENT_SET>
</xsl:template>

<xsl:template match="SampleSet"/>

</xsl:stylesheet>