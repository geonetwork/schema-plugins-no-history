<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
										xmlns:dc ="http://purl.org/dc/elements/1.1/"
										xmlns:dct="http://purl.org/dc/terms/"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gmx="http://www.isotc211.org/2005/gmx"
										xmlns:srv="http://www.isotc211.org/2005/srv"
										xmlns:gml="http://www.opengis.net/gml"
										xmlns:geonet="http://www.fao.org/geonetwork"
										xmlns:ows="http://www.opengis.net/ows"
										exclude-result-prefixes="gmd srv gco gmx">

	<xsl:param name="displayInfo"/>
	<xsl:param name="lang"/>
	
	<xsl:include href="../metadata-iso19139-utils.xsl"/>
	
	<!-- ============================================================================= -->

	<xsl:template match="gmd:MD_Metadata|*[@gco:isoType='gmd:MD_Metadata']">
		
		<xsl:variable name="info" select="geonet:info"/>
		<xsl:variable name="langId">
			<xsl:call-template name="getLangId">
				<xsl:with-param name="langGui" select="$lang"/>
				<xsl:with-param name="md" select="."/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="identification" select="gmd:identificationInfo/gmd:MD_DataIdentification|
			gmd:identificationInfo/*[@gco:isoType='gmd:MD_DataIdentification']|
			gmd:identificationInfo/srv:SV_ServiceIdentification|
			gmd:identificationInfo/*[@gco:isoType='srv:SV_ServiceIdentification']"/>
		
		<csw:Record>

			<xsl:for-each select="gmd:fileIdentifier">
				<dc:identifier><xsl:value-of select="gco:CharacterString"/></dc:identifier>
			</xsl:for-each>

			<xsl:for-each select="gmd:dateStamp">
				<dc:date><xsl:value-of select="gco:Date|gco:DateTime"/></dc:date>
			</xsl:for-each>

			<!-- DataIdentification - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="$identification/gmd:citation/gmd:CI_Citation">	
				<xsl:for-each select="gmd:title">
					<dc:title>
						<xsl:apply-templates mode="localised" select=".">
								<xsl:with-param name="langId" select="$langId"/>
						</xsl:apply-templates>
					</dc:title>
				</xsl:for-each>
				
				<!-- Type - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
				
				<xsl:for-each select="../../../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue">
					<dc:type>
						<xsl:apply-templates mode="localised" select=".">
								<xsl:with-param name="langId" select="$langId"/>
						</xsl:apply-templates>
					</dc:type>
				</xsl:for-each>
				
				<!-- subject -->
				
				<xsl:for-each select="../../gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword">
					<dc:subject>
						<xsl:apply-templates mode="localised" select=".">
								<xsl:with-param name="langId" select="$langId"/>
						</xsl:apply-templates>
					</dc:subject>
				</xsl:for-each>
				<xsl:for-each select="../../gmd:topicCategory/gmd:MD_TopicCategoryCode">
					<dc:subject><xsl:value-of select="."/></dc:subject><!-- TODO : translate ? -->
				</xsl:for-each>
				
				
				<!-- Distribution - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
				
				<xsl:for-each select="../../../../gmd:distributionInfo/gmd:MD_Distribution">
					<xsl:for-each select="gmd:distributionFormat/gmd:MD_Format/gmd:name">
						<dc:format>
							<xsl:apply-templates mode="localised" select=".">
								<xsl:with-param name="langId" select="$langId"/>
							</xsl:apply-templates>
						</dc:format>
					</xsl:for-each>
				</xsl:for-each>
				
				
				<xsl:for-each select="gmd:date/gmd:CI_Date[gmd:dateType/gmd:CI_DateTypeCode/@codeListValue='revision']/gmd:date/gco:Date">
					<dct:modified><xsl:value-of select="."/></dct:modified>
				</xsl:for-each>

				<xsl:for-each select="gmd:citedResponsibleParty/gmd:CI_ResponsibleParty[gmd:role/gmd:CI_RoleCode/@codeListValue='originator']/gmd:organisationName">
					<dc:creator>
						<xsl:apply-templates mode="localised" select=".">
							<xsl:with-param name="langId" select="$langId"/>
						</xsl:apply-templates>
					</dc:creator>
				</xsl:for-each>

				<xsl:for-each select="gmd:citedResponsibleParty/gmd:CI_ResponsibleParty[gmd:role/gmd:CI_RoleCode/@codeListValue='publisher']/gmd:organisationName">
					<dc:publisher>
						<xsl:apply-templates mode="localised" select=".">
							<xsl:with-param name="langId" select="$langId"/>
						</xsl:apply-templates>
					</dc:publisher>
				</xsl:for-each>

				<xsl:for-each select="gmd:citedResponsibleParty/gmd:CI_ResponsibleParty[gmd:role/gmd:CI_RoleCode/@codeListValue='author']/gmd:organisationName">
					<dc:contributor>
						<xsl:apply-templates mode="localised" select=".">
							<xsl:with-param name="langId" select="$langId"/>
						</xsl:apply-templates>					
					</dc:contributor>
				</xsl:for-each>
			</xsl:for-each>

			
			<!-- abstract -->

			<xsl:for-each select="$identification/gmd:abstract">
				<dct:abstract>
					<xsl:apply-templates mode="localised" select=".">
						<xsl:with-param name="langId" select="$langId"/>
					</xsl:apply-templates>				
				</dct:abstract>
				<dc:description>
					<xsl:apply-templates mode="localised" select=".">
						<xsl:with-param name="langId" select="$langId"/>
					</xsl:apply-templates>				
				</dc:description>
			</xsl:for-each>

			<!-- rights -->

			<xsl:for-each select="$identification/gmd:resourceConstraints/gmd:MD_LegalConstraints|
				gmd:resourceConstraints/*[@gco:isoType='gmd:MD_LegalConstraints']">
				<xsl:for-each select="*/gmd:MD_RestrictionCode/@codeListValue">
					<dc:rights><xsl:value-of select="."/></dc:rights>
				</xsl:for-each>

				<xsl:for-each select="$identification/otherConstraints">
					<dc:rights>
						<xsl:apply-templates mode="localised" select=".">
							<xsl:with-param name="langId" select="$langId"/>
						</xsl:apply-templates>									
					</dc:rights>
				</xsl:for-each>
			</xsl:for-each>

			<!-- language -->

			<xsl:for-each select="$identification/gmd:language/gco:CharacterString">
				<dc:language><xsl:value-of select="."/></dc:language>
			</xsl:for-each>
			
			<!-- Lineage -->
			
			<xsl:for-each select="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:statement">
				<dc:source>
					<xsl:apply-templates mode="localised" select=".">
						<xsl:with-param name="langId" select="$langId"/>
					</xsl:apply-templates>				
				</dc:source>
			</xsl:for-each>
			
			<!-- Parent Identifier -->
			
			<xsl:for-each select="gmd:parentIdentifier/gco:CharacterString">
				<dc:relation><xsl:value-of select="."/></dc:relation>
			</xsl:for-each>


			<!-- Distribution - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
			
			<xsl:for-each select="gmd:distributionInfo/gmd:MD_Distribution">
				<xsl:for-each select="gmd:distributionFormat/gmd:MD_Format/gmd:name">
					<dc:format>
						<xsl:apply-templates mode="localised" select=".">
							<xsl:with-param name="langId" select="$langId"/>
						</xsl:apply-templates>
					</dc:format>
				</xsl:for-each>
			</xsl:for-each>				

			<!-- temporal extent -->

			<xsl:for-each select="$identification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod">
				<dc:coverage>name="<xsl:value-of select="@gml:id"/>"; start="<xsl:value-of select="gml:beginPosition|gml:begin/gml:TimeInstant/gml:timePosition"/>"; end="<xsl:value-of select="gml:endPosition|gml:end/gml:TimeInstant/gml:timePosition"/>"
				</dc:coverage>
			</xsl:for-each>

			<!-- bounding box -->

			<xsl:for-each select="$identification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox">
				<xsl:variable name="rsi"  select="/gmd:MD_Metadata/gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/
					gmd:referenceSystemIdentifier/gmd:RS_Identifier|/gmd:MD_Metadata/gmd:referenceSystemInfo/
					*[@gco:isoType='MD_ReferenceSystem']/gmd:referenceSystemIdentifier/gmd:RS_Identifier"/>
				<xsl:variable name="auth" select="$rsi/gmd:codeSpace/gco:CharacterString"/>
				<xsl:variable name="id"   select="$rsi/gmd:code/gco:CharacterString"/>
				<xsl:variable name="crs" select="concat('urn:ogc:def:crs:', $auth, '::', $id)"/>

				<ows:BoundingBox>
					<xsl:attribute name="crs">
						<xsl:choose>
							<xsl:when test="$crs = 'urn:ogc:def:crs:::'">urn:ogc:def:crs:EPSG:6.6:4326</xsl:when>
							<xsl:otherwise><xsl:value-of select="$crs"/></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					<ows:LowerCorner>
						<xsl:value-of select="concat(gmd:eastBoundLongitude/gco:Decimal, ' ', gmd:southBoundLatitude/gco:Decimal)"/>
					</ows:LowerCorner>
	
					<ows:UpperCorner>
						<xsl:value-of select="concat(gmd:westBoundLongitude/gco:Decimal, ' ', gmd:northBoundLatitude/gco:Decimal)"/>
					</ows:UpperCorner>
				</ows:BoundingBox>
			</xsl:for-each>


			<!-- Create as many URI element 
				* thumbnails
				* dataset online source elements
				* as coupledResource defined for a WMS service. 
				 * Get one connect point for the service
				 * Add as many layers defined in coupled resource elements.

				With this information, client could access to onlinesource defined in the metadata.
				
				CSW 2.0.2 ISO profil does not support dc:URI elements.
				What could be done is to add an output format supporting dclite4g 
				http://wiki.osgeo.org/wiki/DCLite4G (TODO)
				-->
			<xsl:for-each select="
				gmd:identificationInfo/srv:SV_ServiceIdentification[srv:serviceType/gco:LocalName='OGC:WMS']|
				gmd:identificationInfo/*[@gco:isoType='srv:SV_ServiceIdentification' and srv:serviceType/gco:LocalName='OGC:WMS']">
				
				<xsl:variable name="connectPoint" select="srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
				<xsl:variable name="serviceUrl">
					<xsl:choose>
						<xsl:when test="$connectPoint=''">
							<xsl:value-of select="../gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$connectPoint"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<dc:URI protocol="OGC:WMS-1.1.1-http-get-capabilities"><xsl:value-of select="$serviceUrl"/></dc:URI>
				<xsl:for-each select="srv:coupledResource/srv:SV_CoupledResource">
					<xsl:if test="gco:ScopedName!=''">
						<dc:URI protocol="OGC:WMS" name="{gco:ScopedName}"><xsl:value-of select="$serviceUrl"/></dc:URI>
					</xsl:if>
				</xsl:for-each>
				 
			</xsl:for-each>
			
			
			<xsl:for-each select="gmd:distributionInfo/gmd:MD_Distribution">
				<xsl:for-each select="gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource">
					<xsl:if test="gmd:linkage">
						<dc:URI>
							<xsl:if test="gmd:protocol">
								<xsl:attribute name="protocol"><xsl:value-of select="gmd:protocol/gco:CharacterString"/></xsl:attribute>
							</xsl:if>
							
							<xsl:if test="normalize-space(gmd:name/*)!=''">
								<xsl:attribute name="name">
									<xsl:for-each select="gmd:name">
										<!-- <xsl:apply-templates mode="localised" select=".">
											<xsl:with-param name="langId" select="$langId"/>
										</xsl:apply-templates> -->
										<xsl:value-of select="gco:CharacterString|gmx:MimeFileType"/>
									</xsl:for-each>
								</xsl:attribute>
							</xsl:if>
							
							<xsl:if test="gmd:name/gmx:MimeFileType/@type">
								<xsl:attribute name="type">
									<xsl:value-of select="gmd:name/gmx:MimeFileType/@type"/>
								</xsl:attribute>
							</xsl:if>
							
							<xsl:if test="gmd:description">
								<xsl:attribute name="description">
									<xsl:for-each select="gmd:description">
										<xsl:apply-templates mode="localised" select=".">
											<xsl:with-param name="langId" select="$langId"/>
										</xsl:apply-templates>
									</xsl:for-each>
								</xsl:attribute>
							</xsl:if>
							
							<xsl:value-of select="gmd:linkage/gmd:URL"/>
						</dc:URI>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>

			<xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:graphicOverview/gmd:MD_BrowseGraphic">
				<xsl:variable name="fileName" select="gmd:fileName/gco:CharacterString"/>
				<xsl:variable name="fileDescr" select="gmd:fileDescription/gco:CharacterString"/>
				
				<xsl:if test="$fileName!='' and $fileDescr='thumbnail'">
					<dc:URI>
						<xsl:choose>
							<xsl:when test="contains(gmd:fileName/gco:CharacterString, '.gif')">
								<xsl:attribute name="protocol">image/gif</xsl:attribute>
							</xsl:when>
							<xsl:when test="contains(gmd:fileName/gco:CharacterString, '.png')">
								<xsl:attribute name="protocol">image/png</xsl:attribute>
							</xsl:when>
						</xsl:choose>
						
						<xsl:if test="$fileDescr">
							<xsl:attribute name="name"><xsl:value-of select="$fileDescr"/></xsl:attribute>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="contains($fileName ,'://')"><xsl:value-of select="$fileName"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="concat('resources.get?id=',$info/id,'&amp;fname=',$fileName,'&amp;access=public')"/>
							</xsl:otherwise>
						</xsl:choose>
						
					</dc:URI>
				</xsl:if>
			</xsl:for-each>
			
			<!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
			<xsl:if test="$displayInfo = 'true'">
				<xsl:copy-of select="$info"/>
            </xsl:if>
			
		</csw:Record>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*">
		<xsl:apply-templates select="*"/>
	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
