<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!--

This Schematron schema merges three sets of Schematron rules
1. Schematron rules embedded in the GML 3.2 schema
2. Schematron rules implementing the Additional Constraints described in 
   ISO 19139 Table A.1
3. INSPIRE IR on metadata for datasets and services.


This script was written by CSIRO for the Australia-New Zealand Land 
Information Council (ANZLIC) as part of a project to develop an XML 
implementation of the ANZLIC ISO Metadata Profile. 

December 2006, March 2007

Port back to good old Schematron-1.5 for use with schematron-report.xsl
and change titles for use as bare bones 19115/19139 schematron checker 
in GN 2.2 onwards.

Simon Pigot, 2007
Francois Prunayre, 2008
Etienne Taffoureau, 2008

Add MCP rules

Simon Pigot
February 8, 2011

Add more MCP rules for CI_Responsibility

Simon Pigot
February 8, 2011

This work is licensed under the Creative Commons Attribution 2.5 License. 
To view a copy of this license, visit 
    http://creativecommons.org/licenses/by/2.5/au/ 

or send a letter to:

Creative Commons, 
543 Howard Street, 5th Floor, 
San Francisco, California, 94105, 
USA.

-->

	<sch:title xmlns="http://www.w3.org/2001/XMLSchema">Schematron validation for Marine Community Profile (Versions 1.4 and 1.5-Experimental) of AS/NZS 19115(19139)</sch:title>
	<sch:ns prefix="gml" uri="http://www.opengis.net/gml"/>
	<sch:ns prefix="gmd" uri="http://www.isotc211.org/2005/gmd"/>
	<sch:ns prefix="srv" uri="http://www.isotc211.org/2005/srv"/>
	<sch:ns prefix="gco" uri="http://www.isotc211.org/2005/gco"/>
	<sch:ns prefix="mcp" uri="http://bluenet3.antcrc.utas.edu.au/mcp"/>
	<sch:ns prefix="geonet" uri="http://www.fao.org/geonetwork"/>
	<sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>

	<!-- Test that every CharacterString element has content or it's parent has a
   		 valid nilReason attribute value - this is not necessary for geonetwork 
			 because update-fixed-info.xsl supplies a gco:nilReason of missing for 
			 all gco:CharacterString elements with no content and removes it if the
			 user fills in a value - this is the same for all gco:nilReason tests 
			 used below - the test for gco:nilReason in 'inapplicable....' etc is
			 "mickey mouse" for that reason. -->
	<sch:pattern>
		<sch:title>$loc/strings/M6</sch:title>
		<sch:rule context="*[gco:CharacterString]">
			<sch:report
				test="(normalize-space(gco:CharacterString) = '') and (not(@gco:nilReason) or not(contains('inapplicable missing template unknown withheld',@gco:nilReason)))"
				>$loc/strings/alert.M6.characterString</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern>
		<sch:title>$loc/strings/M7</sch:title>
		<!-- UNVERIFIED -->
		<sch:rule id="CRSLabelsPosType" context="//gml:DirectPositionType">
			<sch:report test="not(@srsDimension) or @srsName"
				>$loc/strings/alert.M6.directPosition</sch:report>
			<sch:report test="not(@axisLabels) or @srsName"
				>$loc/strings/alert.M7.axisAndSrs</sch:report>
			<sch:report test="not(@uomLabels) or @srsName"
				>$loc/strings/alert.M7.uomAndSrs</sch:report>
			<sch:report
				test="(not(@uomLabels) and not(@axisLabels)) or (@uomLabels and @axisLabels)"
				>$loc/strings/alert.M7.uomAndAxis</sch:report>
		</sch:rule>
	</sch:pattern>

	<!--mcpExtensions.xsd - check CI_Organisation has a name -->
	<sch:pattern>
		<sch:title>$loc/strings/M32</sch:title>
		<sch:rule context="//*[mcp:CI_Organisation]">
			<sch:let name="countName" value="count(mcp:CI_Organisation/mcp:name[@gco:nilReason!='missing' or not(@gco:nilReason)])"/>
			<sch:assert
				test="$countName > 0"
				>$loc/strings/alert.M32</sch:assert>
			<sch:report
				test="$countName > 0"
				><sch:value-of select="$loc/strings/report.M32"/> 
				<sch:value-of select="mcp:CI_Organisation/mcp:name"/>-
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<!--mcpExtensions.xsd - check CI_Individual have a name or positionName -->
	<sch:pattern>
		<sch:title>$loc/strings/M33</sch:title>
		<sch:rule context="//*[mcp:CI_Individual]">
			<sch:let name="count" value="(count(mcp:CI_Individual/mcp:name[@gco:nilReason!='missing' or not(@gco:nilReason)]) 
				+ count(mcp:CI_Individual/mcp:positionName[@gco:nilReason!='missing' or not(@gco:nilReason)]))"/>
			<sch:assert
				test="$count > 0"
				>$loc/strings/alert.M33</sch:assert>
			<sch:report
				test="$count > 0"
				><sch:value-of select="$loc/strings/report.M33"/> 
				<sch:value-of select="mcp:CI_Individual/mcp:name"/>-
				<sch:value-of select="mcp:CI_Individual/mcp:positionName"/>
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<!--anzlic/trunk/gml/3.2.0/gmd/citation.xsd-->
	<!-- TEST 21 FXCHECK -->
	<sch:pattern>
		<sch:title>$loc/strings/M8</sch:title>
		<sch:rule context="//*[gmd:CI_ResponsibleParty]">
			<sch:let name="count" value="(count(gmd:CI_ResponsibleParty/gmd:individualName[@gco:nilReason!='missing' or not(@gco:nilReason)]) 
				+ count(gmd:CI_ResponsibleParty/gmd:organisationName[@gco:nilReason!='missing' or not(@gco:nilReason)])
				+ count(gmd:CI_ResponsibleParty/gmd:positionName[@gco:nilReason!='missing' or not(@gco:nilReason)]))"/>
			<sch:assert
				test="$count > 0"
				>$loc/strings/alert.M8</sch:assert>
			<sch:report
				test="$count > 0"
				><sch:value-of select="$loc/strings/report.M8"/> 
				<sch:value-of select="gmd:CI_ResponsibleParty/gmd:organisationName"/>-
				<sch:value-of select="gmd:CI_ResponsibleParty/gmd:individualName"/>
			</sch:report>
		</sch:rule>
	</sch:pattern>
	<!-- anzlic/trunk/gml/3.2.0/gmd/constraints.xsd-->
	<!-- TEST  4 FXCHECK -->
	<sch:pattern>
		<sch:title>$loc/strings/M9</sch:title>
		<sch:rule context="//gmd:MD_LegalConstraints[gmd:accessConstraints/gmd:MD_RestrictionCode/@codeListValue='otherRestrictions']
			|//*[@gco:isoType='gmd:MD_LegalConstraints' and gmd:accessConstraints/gmd:MD_RestrictionCode/@codeListValue='otherRestrictions']">
			<sch:let name="access" value="(not(gmd:otherConstraints) or gmd:otherConstraints/@gco:nilReason='missing')"/>
			<sch:assert
				test="$access = false()"
				>
				<sch:value-of select="$loc/strings/alert.M9.access"/>
			</sch:assert>
			<sch:report
				test="$access = false()"
				><sch:value-of select="$loc/strings/report.M9"/>
				<sch:value-of select="gmd:otherConstraints/gco:CharacterString"/>
			</sch:report>
		</sch:rule>
		<sch:rule context="//gmd:MD_LegalConstraints[gmd:useConstraints/gmd:MD_RestrictionCode/@codeListValue='otherRestrictions']
			|//*[@gco:isoType='gmd:MD_LegalConstraints' and gmd:accessConstraints/gmd:MD_RestrictionCode/@codeListValue='otherRestrictions']">
			<sch:let name="use" value="(not(gmd:otherConstraints) or gmd:otherConstraints/@gco:nilReason='missing')"/>
			<sch:assert
				test="$use = false()"
				><sch:value-of select="$loc/strings/alert.M9.use"/>
			</sch:assert>
			<sch:report
				test="$use = false()"
				><sch:value-of select="$loc/strings/report.M9"/>
				<sch:value-of select="gmd:otherConstraints/gco:CharacterString"/>
			</sch:report>
		</sch:rule>
	</sch:pattern>
	<!-- anzlic/trunk/gml/3.2.0/gmd/content.xsd-->
	<!-- TEST 13 FXCHECK -->
	<sch:pattern>
		<sch:title>$loc/strings/M10</sch:title>
		<sch:rule context="//gmd:MD_Band[gmd:maxValue or gmd:minValue]">
			<sch:let name="values" value="(gmd:maxValue[@gco:nilReason!='missing' or not(@gco:nilReason)]
				or gmd:minValue[@gco:nilReason!='missing' or not(@gco:nilReason)]) 
				and not(gmd:units)"/>
			<sch:assert test="$values = false()"
				><sch:value-of select="$loc/strings/alert.M9"/>
			</sch:assert>
			<sch:report test="$values = false()"
				>
				<sch:value-of select="$loc/strings/report.M9.min"/>
				<sch:value-of select="gmd:minValue"/> / 
				<sch:value-of select="$loc/strings/report.M9.max"/>
				<sch:value-of select="gmd:maxValue"/> [
				<sch:value-of select="$loc/strings/report.M9.units"/>
				<sch:value-of select="gmd:units"/>]
			</sch:report>
			<!-- FIXME : Rename to alert M10 -->
		</sch:rule>
	</sch:pattern>
	<!-- anzlic/trunk/gml/3.2.0/gmd/dataQuality.xsd -->
	<!-- TEST 10 FXCHECK -->
	<sch:pattern>
		<sch:title>$loc/strings/M11</sch:title>
		<sch:rule context="//gmd:LI_Source">
			<sch:let name="extent" value="gmd:description[@gco:nilReason!='missing' or not(@gco:nilReason)] or gmd:sourceExtent"/>
			<sch:assert test="$extent"
				>$loc/strings/alert.M11</sch:assert>
			<sch:report test="$extent"
				>$loc/strings/report.M11</sch:report>
		</sch:rule>
	</sch:pattern>
	<!-- TEST  7 FXCHECK -->
	<sch:pattern>
		<sch:title>$loc/strings/M13</sch:title>
		<sch:rule context="//gmd:DQ_DataQuality[gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode/@codeListValue='dataset' 
			or gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode/@codeListValue='series']">
			<sch:let name="emptyStatement" value="
				count(*/gmd:LI_Lineage/gmd:source) + count(*/gmd:LI_Lineage/gmd:processStep) = 0 
				and not(gmd:lineage/gmd:LI_Lineage/gmd:statement[@gco:nilReason!='missing' or not(@gco:nilReason)]) 
				"/>
			<sch:assert
				test="$emptyStatement = false()"
				>$loc/strings/alert.M13</sch:assert>
			<sch:report
				test="$emptyStatement = false()"
				>$loc/strings/report.M13</sch:report>
		</sch:rule>
	</sch:pattern>
	<!-- TEST  8 FXCHECK -->
	<sch:pattern>
		<sch:title>$loc/strings/M14</sch:title>
		<sch:rule context="//gmd:LI_Lineage">
			<sch:let name="emptySource" value="not(gmd:source) 
				and not(gmd:statement[@gco:nilReason!='missing' or not(@gco:nilReason)]) 
				and not(gmd:processStep)"/>
			<sch:assert test="$emptySource = false()"
				>$loc/strings/alert.M14</sch:assert>
			<sch:report test="$emptySource = false()"
				>$loc/strings/report.M14</sch:report>

			<sch:let name="emptyProcessStep" value="not(gmd:processStep) 
				and not(gmd:statement[@gco:nilReason!='missing' or not(@gco:nilReason)])
				and not(gmd:source)"/>
			<sch:assert test="$emptyProcessStep = false()"
				>$loc/strings/alert.M15</sch:assert>
			<sch:report test="$emptyProcessStep = false()"
				>$loc/strings/report.M15</sch:report>
		</sch:rule>
	</sch:pattern>
	<!-- TEST 5 FXCHECK -->
	<sch:pattern>
		<sch:title>$loc/strings/M16</sch:title>
		<sch:rule context="//gmd:DQ_DataQuality[gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode/@codeListValue='dataset']">
			<sch:let name="noReportNorLineage" value="not(gmd:report) 
				and not(gmd:lineage)"/>
			<sch:assert
				test="$noReportNorLineage = false()"
				>$loc/strings/alert.M16</sch:assert>
			<sch:report
				test="$noReportNorLineage = false()"
				>$loc/strings/report.M16</sch:report>
		</sch:rule>
	</sch:pattern>
	<!-- TEST  6 FXCHECK -->
	<sch:pattern>
		<sch:title>$loc/strings/M17</sch:title>
		<sch:rule context="//gmd:DQ_Scope">
			<sch:let name="levelDesc" value="gmd:level/gmd:MD_ScopeCode/@codeListValue='dataset' 
				or gmd:level/gmd:MD_ScopeCode/@codeListValue='series' 
				or (gmd:levelDescription and ((normalize-space(gmd:levelDescription) != '') 
				or (gmd:levelDescription/gmd:MD_ScopeDescription) 
				or (gmd:levelDescription/@gco:nilReason 
				and contains('inapplicable missing template unknown withheld',gmd:levelDescription/@gco:nilReason))))"/>
			<sch:assert
				test="$levelDesc"
				>$loc/strings/alert.M17</sch:assert>
			<sch:report
				test="$levelDesc"
				><sch:value-of select="$loc/strings/report.M17"/> <sch:value-of select="gmd:levelDescription"/></sch:report>
		</sch:rule>
	</sch:pattern>
	<!-- anzlic/trunk/gml/3.2.0/gmd/distribution.xsd-->
	<!-- TEST 14 FXCHECK -->
	<sch:pattern>
		<sch:title>$loc/strings/M18</sch:title>
		<sch:rule context="//gmd:MD_Medium">
			<sch:let name="density" value="gmd:density and not(gmd:densityUnits[@gco:nilReason!='missing' or not(@gco:nilReason)])"/>
			<sch:assert test="$density = false()"
				>$loc/strings/alert.M18</sch:assert>
			<sch:report test="$density = false()"
				><sch:value-of select="$loc/strings/report.M18"/> <sch:value-of select="gmd:density"/> 
				<sch:value-of select="gmd:densityUnits/gco:CharacterString"/></sch:report>
		</sch:rule>
	</sch:pattern>
	<!-- TEST15 FXCHECK -->
	<sch:pattern>
		<sch:title>$loc/strings/M19</sch:title>
		<sch:rule context="//gmd:MD_Distribution">
			<sch:let name="total" value="count(gmd:distributionFormat) +
				count(gmd:distributor/gmd:MD_Distributor/gmd:distributorFormat)"/>
			<sch:let name="count" value="count(gmd:distributionFormat)>0 
				or count(gmd:distributor/gmd:MD_Distributor/gmd:distributorFormat)>0"/>
			<sch:assert
				test="$count"
				>$loc/strings/alert.M19</sch:assert>
			<sch:report
				test="$count"
				><sch:value-of select="$total"/> <sch:value-of select="$loc/strings/report.M19"/></sch:report>
		</sch:rule>
	</sch:pattern>
	<!-- anzlic/trunk/gml/3.2.0/gmd/extent.xsd-->
	<!-- TEST 20 FXCHECK -->
	<sch:pattern>
		<sch:title>$loc/strings/M20</sch:title>
		<sch:rule context="//gmd:EX_Extent">
			<sch:let name="count" value="count(gmd:description[@gco:nilReason!='missing' or not(@gco:nilReason)])>0 
				or count(gmd:geographicElement)>0 
				or count(gmd:temporalElement)>0 
				or count(gmd:verticalElement)>0"/>
			<sch:assert
				test="$count"
				>$loc/strings/alert.M20</sch:assert>
			<sch:report
				test="$count"
				>$loc/strings/report.M20</sch:report>
		</sch:rule>
	</sch:pattern>
	<!-- TEST  1 -->
	<sch:pattern>
		<sch:title>$loc/strings/M21</sch:title>
		<sch:rule context="//gmd:MD_DataIdentification|//*[@gco:isoType='gmd:MD_DataIdentification']">
			<sch:let name="extent" value="(not(../../gmd:hierarchyLevel) 
				or ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='dataset' 
				or ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='') 
				and (count(gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox) 
				+ count (gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicDescription))=0"/>
			<sch:assert
				test="$extent = false()"
				>$loc/strings/alert.M21</sch:assert>
			<sch:report
				test="$extent = false()"
				>$loc/strings/report.M21</sch:report>
		</sch:rule>
	</sch:pattern>
	<!-- TEST  2 -->
	<sch:pattern>
		<sch:title>$loc/strings/M22</sch:title>
		<sch:rule context="//gmd:MD_DataIdentification|//*[@gco:isoType='gmd:MD_DataIdentification']">
			<sch:let name="topic" value="(not(../../gmd:hierarchyLevel) 
				or ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='dataset' 
				or ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='series'  
				or ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='' )
				and not(gmd:topicCategory)"/>
			<sch:assert
				test="$topic = false"
				>$loc/strings/alert.M6</sch:assert>
			<sch:report
				test="$topic = false"
				><sch:value-of select="$loc/strings/report.M6"/> "<sch:value-of select="gmd:topicCategory"/>"</sch:report>
		</sch:rule>
	</sch:pattern>
	<!-- TEST  3 -->
	<sch:pattern>
		<sch:title>$loc/strings/M23</sch:title>
		<sch:rule context="//gmd:MD_AggregateInformation">
			<sch:assert test="gmd:aggregateDataSetName or gmd:aggregateDataSetIdentifier"
				>$loc/strings/alert.M23</sch:assert>
			<sch:report test="gmd:aggregateDataSetName or gmd:aggregateDataSetIdentifier"
				>$loc/strings/report.M23</sch:report>
		</sch:rule>
	</sch:pattern>
	<!-- anzlic/trunk/gml/3.2.0/gmd/metadataEntity.xsd: -->
	<!--<sch:pattern>
		<sch:title>$loc/strings/M24</sch:title>
		<!-\- UNVERIFIED -\->
		<sch:rule
			context="//gmd:MD_Metadata/gmd:language|//*[@gco:isoType='gmd:MD_Metadata']/gmd:language">
			<sch:assert
				test=". and ((normalize-space(.) != '') 
      				or (normalize-space(./gco:CharacterString) != '') 
      				or (./gmd:LanguageCode) 
      				or (./@gco:nilReason 
      					and contains('inapplicable missing template unknown withheld',./@gco:nilReason)))"
				>$loc/strings/alert.M24</sch:assert>
			<!-\- language: documented if not defined by the encoding standard. 
					 It can't be documented by the encoding because GML doesn't 
					 include xml:language. -\->
		</sch:rule>
	</sch:pattern>-->
	<sch:pattern>
		<sch:title>$loc/strings/M25</sch:title>
		<!-- UNVERIFIED -->
		<sch:rule context="//gmd:MD_Metadata|//*[@gco:isoType='gmd:MD_Metadata']">
			<!-- characterSet: documented if ISO/IEC 10646 not used and not defined by
        the encoding standard. Can't tell if XML declaration has an encoding
        attribute. -->
		</sch:rule>
	</sch:pattern>

	<!-- anzlic/trunk/gml/3.2.0/gmd/metadataExtension.xsd-->
	<!-- TEST 16 -->
	<sch:pattern>
		<sch:title>$loc/strings/M26</sch:title>
		<sch:rule context="//gmd:MD_ExtendedElementInformation">
			<sch:assert
				test="(gmd:dataType/gmd:MD_DatatypeCode/@codeListValue='codelist' 
				or gmd:dataType/gmd:MD_DatatypeCode/@codeListValue='enumeration' 
				or gmd:dataType/gmd:MD_DatatypeCode/@codeListValue='codelistElement') 
				or (gmd:obligation and ((normalize-space(gmd:obligation) != '')  
				or (gmd:obligation/gmd:MD_ObligationCode) 
				or (gmd:obligation/@gco:nilReason and contains('inapplicable missing template unknown withheld',gmd:obligation/@gco:nilReason))))"
				>$loc/strings/alert.M26.obligation</sch:assert>
			<sch:assert
				test="(gmd:dataType/gmd:MD_DatatypeCode/@codeListValue='codelist' 
				or gmd:dataType/gmd:MD_DatatypeCode/@codeListValue='enumeration' 
				or gmd:dataType/gmd:MD_DatatypeCode/@codeListValue='codelistElement') 
				or (gmd:maximumOccurrence and ((normalize-space(gmd:maximumOccurrence) != '')  
				or (normalize-space(gmd:maximumOccurrence/gco:CharacterString) != '') 
				or (gmd:maximumOccurrence/@gco:nilReason and contains('inapplicable missing template unknown withheld',gmd:maximumOccurrence/@gco:nilReason))))"
				>$loc/strings/alert.M26.maximumOccurence</sch:assert>
			<sch:assert
				test="(gmd:dataType/gmd:MD_DatatypeCode/@codeListValue='codelist' 
				or gmd:dataType/gmd:MD_DatatypeCode/@codeListValue='enumeration' 
				or gmd:dataType/gmd:MD_DatatypeCode/@codeListValue='codelistElement') 
				or (gmd:domainValue and ((normalize-space(gmd:domainValue) != '')  
				or (normalize-space(gmd:domainValue/gco:CharacterString) != '') 
				or (gmd:domainValue/@gco:nilReason and contains('inapplicable missing template unknown withheld',gmd:domainValue/@gco:nilReason))))"
				>$loc/strings/alert.M26.domainValue</sch:assert>
		</sch:rule>
	</sch:pattern>
	<!-- TEST 17 -->
	<sch:pattern>
		<sch:title>$loc/strings/M27</sch:title>
		<sch:rule context="//gmd:MD_ExtendedElementInformation">
			<sch:let name="condition" value="gmd:obligation/gmd:MD_ObligationCode='conditional'
				and (not(gmd:condition) or count(gmd:condition[@gco:nilReason='missing'])>0)"/>
			<sch:assert
				test="$condition = false()"
				>
				<sch:value-of select="$loc/strings/alert.M27"/>
			</sch:assert>
			<sch:report
				test="$condition = false()"
				>
				<sch:value-of select="$loc/strings/report.M27"/>
			</sch:report>
		</sch:rule>
	</sch:pattern>
	<!-- TEST 18 -->
	<sch:pattern>
		<sch:title>$loc/strings/M28</sch:title>
		<sch:rule context="//gmd:MD_ExtendedElementInformation">
			<sch:let name="domain" value="gmd:dataType/gmd:MD_DatatypeCode/@codeListValue='codelistElement' and not(gmd:domainCode)"/>
			<sch:assert
				test="$domain = false()"
				>$loc/strings/alert.M28</sch:assert>
			<sch:report
				test="$domain = false()"
				>$loc/strings/report.M28</sch:report>
		</sch:rule>
	</sch:pattern>
	<!-- TEST 19 -->
	<sch:pattern>
		<sch:title>$loc/strings/M29</sch:title>
		<sch:rule context="//gmd:MD_ExtendedElementInformation">
			<sch:let name="shortName" value="gmd:dataType/gmd:MD_DatatypeCode/@codeListValue!='codelistElement' and not(gmd:shortName)"/>
			<sch:assert
				test="$shortName = false()"
				>$loc/strings/alert.M29</sch:assert>
			<sch:report
				test="$shortName = false()"
				>$loc/strings/report.M29</sch:report>
		</sch:rule>
	</sch:pattern>
	<!-- anzlic/trunk/gml/3.2.0/gmd/spatialRepresentation.xsd-->
	<!-- TEST 12 -->
	<sch:pattern>
		<sch:title>$loc/strings/M30</sch:title>
		<sch:rule context="//gmd:MD_Georectified">
			<sch:let name="cpd" value="(gmd:checkPointAvailability/gco:Boolean='1' or gmd:checkPointAvailability/gco:Boolean='true') and 
				(not(gmd:checkPointDescription) or count(gmd:checkPointDescription[@gco:nilReason='missing'])>0)"/>
			<sch:assert
				test="$cpd = false()"
				>$loc/strings/alert.M30</sch:assert>
			<sch:report
				test="$cpd = false()"
				>$loc/strings/report.M30</sch:report>
		</sch:rule>
	</sch:pattern>
	<!--  -->
	<sch:pattern>
		<sch:title>$loc/strings/M61</sch:title>
		<sch:rule context="//gmd:MD_Metadata/gmd:hierarchyLevel|//*[@gco:isoType='gmd:MD_Metadata']/gmd:hierarchyLevel">
			<sch:let name="hl" value="(gmd:MD_ScopeCode/@codeListValue!='' and gmd:MD_ScopeCode/@codeListValue!='dataset') and 
				(not(../gmd:hierarchyLevelName) or ../gmd:hierarchyLevelName/@gco:nilReason)"/>
			<sch:assert
				test="$hl = false()"
				>$loc/strings/alert.M61</sch:assert>
			<sch:report
				test="$hl = false()"
				><sch:value-of select=" $loc/strings/report.M61"/> "<sch:value-of select="../gmd:hierarchyLevelName"/>"</sch:report>
		</sch:rule>
	</sch:pattern>

	<!-- MCP extensions -->

	<sch:pattern>
		<sch:title>mcp:MD_Metadata/gmd:dateStamp required</sch:title>
		<sch:rule context="//mcp:MD_Metadata">
			<sch:assert test="count(gmd:dateStamp) >= 1">dateStamp is not present.</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!--2.4.2 pg 8 MCP Standard -->
  <!-- FIXME: mcp:MD_Identification is not explicitly defined in the current MCP
       schema - all elements that should be in it are actually in
       mcp:MD_DataIdentification -->
  <sch:pattern>
		<sch:title>gmd:identificationInfo/mcp:MD_DataIdentification requires citation, abstract, credit, status, pointOfContact</sch:title>
    <sch:rule context="//mcp:MD_DataIdentification">
      <sch:assert test="count(gmd:citation) >= 1">MD_(Data)Identification is missing citation.</sch:assert>
      <sch:assert test="count(gmd:abstract) >= 1">MD_(Data)Identification is missing abstract.</sch:assert>
    <!--  <sch:assert test="count(gmd:credit) >= 1">MD_(Data)Identification is missing credit.</sch:assert>
      <sch:assert test="count(gmd:status) >= 1">MD_(Data)Identification is missing status.</sch:assert> -->
      <sch:assert test="count(gmd:pointOfContact) >= 1">MD_(Data)Identification is missing pointOfContact.</sch:assert>
    </sch:rule>
	</sch:pattern>

	<!-- 2.4.5 pg 8 MCP Standard -->
  <sch:pattern>
		<sch:title>if gmd:resourceMaintenance then must have gmd:maintenanceAndUpdateFrequency</sch:title>
    <sch:rule context="//gmd:resourceMaintenance">
      <sch:assert test="gmd:MD_MaintenanceInformation/gmd:maintenanceAndUpdateFrequency/gmd:MD_MaintenanceFrequencyCode/@codeListValue!=''">maintenanceAndUpdateFrequency is mandatory if resourceMaintenance is documented.</sch:assert>
    </sch:rule>
  </sch:pattern>

	<!-- Required by the MCP standard - box 3 on pg 12 -->
  <sch:pattern>
		<sch:title>dataset must have temporal extent</sch:title>
    <sch:rule context="//mcp:MD_DataIdentification">
      <sch:report test="(not(../../gmd:hierarchyLevel) or ../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='dataset') and count(gmd:extent//gmd:temporalElement/mcp:EX_TemporalExtent) = 0">MD_Metadata/hierarchyLevel = \"dataset\" (i.e. the default value of this property on the parent) implies count (extent//temporalElement/EX_TemporalExtent) &gt;=1.</sch:report>
    </sch:rule>
  </sch:pattern>
	

</sch:schema>
