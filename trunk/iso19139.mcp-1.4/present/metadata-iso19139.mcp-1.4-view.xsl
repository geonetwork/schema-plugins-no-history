<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml="http://www.opengis.net/gml"       xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:geonet="http://www.fao.org/geonetwork" xmlns:exslt="http://exslt.org/common"
  xmlns:mcp="http://bluenet3.antcrc.utas.edu.au/mcp"
  xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon"
  exclude-result-prefixes="mcp gmx xsi gmd gco gml gts srv xlink exslt geonet">

  <!-- View templates are available only in view mode and do not provide 
	     editing capabilities. -->
  <!-- ===================================================================== -->
  <xsl:template name="view-with-header-iso19139.mcp-1.4">
		<xsl:param name="tabs"/>

    <xsl:call-template name="md-content">
      <xsl:with-param name="title">
        <xsl:apply-templates mode="localised"
          select="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:title">
          <xsl:with-param name="langId" select="$langId"/>
        </xsl:apply-templates>
      </xsl:with-param>
      <xsl:with-param name="exportButton"/>
      <xsl:with-param name="abstract">
        <xsl:apply-templates mode="localised" select="gmd:identificationInfo/*/gmd:abstract">
          <xsl:with-param name="langId" select="$langId"/>
        </xsl:apply-templates>
      </xsl:with-param>
      <xsl:with-param name="logo">
        <img src="../../images/logos/{//geonet:info/source}.gif" alt="logo"/>
      </xsl:with-param>
      <xsl:with-param name="relatedResources">
        <xsl:apply-templates mode="relatedResources" select="gmd:distributionInfo"
        />
      </xsl:with-param>
      <xsl:with-param name="tabs" select="$tabs"/>
		</xsl:call-template>
	</xsl:template>

  <!-- View templates are available only in view mode and do not provide 
	     editing capabilities. -->
  <!-- ===================================================================== -->
  <xsl:template name="metadata-iso19139.mcp-1.4view-simple" match="metadata-iso19139.mcp-1.4view-simple">
		<xsl:call-template name="view-with-header-iso19139.mcp-1.4">
      <xsl:with-param name="tabs">
        <xsl:call-template name="complexElementSimpleGui">
          <xsl:with-param name="title"
            select="/root/gui/schemas/iso19139/strings/understandResource"/>
          <xsl:with-param name="content">
            <xsl:apply-templates mode="block"
              select="
                gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation[gmd:date]
                |gmd:identificationInfo/*/gmd:language
                |gmd:topicCategory
                |gmd:identificationInfo/*/gmd:descriptiveKeywords
                |gmd:identificationInfo/*/gmd:graphicOverview[1]
                "> </xsl:apply-templates>
						<!-- process mcp:EX_Extent -->
						<xsl:apply-templates mode="block-mcp" select="gmd:identificationInfo/*/gmd:extent/*/gmd:geographicElement"/>
          </xsl:with-param>
        </xsl:call-template>


        <xsl:call-template name="complexElementSimpleGui">
          <xsl:with-param name="title" select="/root/gui/schemas/iso19139/strings/contactInfo"/>
          <xsl:with-param name="content">
            <xsl:apply-templates mode="block"
              select="gmd:identificationInfo/*/gmd:pointOfContact"/> 
            <xsl:apply-templates mode="block"
              select="gmd:contact"/>
          </xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="complexElementSimpleGui">
          <xsl:with-param name="title" select="/root/gui/schemas/iso19139/strings/techInfo"/>
          <xsl:with-param name="content">
            <xsl:apply-templates mode="block"
              select="
              gmd:identificationInfo/*/gmd:spatialResolution/gmd:MD_Resolution
              |gmd:identificationInfo/*/gmd:spatialRepresentationType
              |gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:statement
              "
            > </xsl:apply-templates>
						<!-- process resourceConstraints using block-mcp as may have 
						     mcp:MD_Commons -->
            <xsl:apply-templates mode="block-mcp"
              select="gmd:identificationInfo/*/gmd:resourceConstraints"/>
          </xsl:with-param>
        </xsl:call-template>


        <span class="madeBy">
          <xsl:value-of select="/root/gui/strings/changeDate"/><xsl:value-of select="string(mcp:revisionDate)"/>
        </span>

      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

	<!-- templates in mode="block" are handled by 
	     metadata-iso19139-view.xsl, we only add those that need
			 special handling here and process them in mode="block-mcp" -->

  <xsl:template mode="block-mcp" match="gmd:resourceConstraints[not(mcp:MD_Commons)]">
    <xsl:call-template name="simpleElementSimpleGUI">
      <xsl:with-param name="title" select="/root/gui/schemas/iso19139/strings/constraintInfo"/>
      <xsl:with-param name="content">
        <xsl:apply-templates mode="iso19139-simple"
          select="*"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="block-mcp" match="gmd:resourceConstraints[mcp:MD_Commons]">
    <xsl:apply-templates mode="iso19139.mcp" select="mcp:MD_Commons">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit" select="false()"/>
    </xsl:apply-templates>
	</xsl:template>

  <xsl:template mode="block-mcp" match="gmd:geographicElement">
    <xsl:apply-templates mode="iso19139.mcp" select="gmd:EX_GeographicBoundingBox">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit" select="false()"/>
    </xsl:apply-templates>
  </xsl:template>

</xsl:stylesheet>
