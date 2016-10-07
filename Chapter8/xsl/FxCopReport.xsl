<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:output method="html"/>

<xsl:variable name="fxcop.root" select="//FxCopReport"/>

<xsl:template match="/">
	<html>
	<head><title>Analysis Report</title></head>
	<style>
		#Title {font-family: Verdana; font-size: 14pt; color: black; font-weight: bold}
		.ColumnHeader {font-family: Verdana; font-size: 8pt; background-color:white; color: black}
		.CriticalError {font-family: Verdana; font-size: 8pt; color: darkred; font-weight: bold; text-align: center}
		.Error {font-family: Verdana; font-size: 8pt; color: royalblue; font-weight: bold; text-align: center}
		.CriticalWarning {font-family: Verdana; font-size: 8pt; color: green; font-weight: bold; text-align: center}
		.Warning {font-family: Verdana; font-size: 8pt; color: darkgray; font-weight: bold; text-align: center}
		.Information {font-family: Verdana; font-size: 8pt; color: black; font-weight: bold; text-align: center}

		.PropertyName {font-family: Verdana; font-size: 8pt; color: black; font-weight: bold}
		.PropertyContent {font-family: Verdana; font-size: 8pt; color: black}
		.NodeIcon { font-family: WebDings; font-size: 12pt; color: navy; padding-right: 5;}
		.MessagesIcon { font-family: WebDings; font-size: 12pt; color: red;}
		.RuleDetails { padding-top: 10;}
		.SourceCode { background-color:#DDDDFF; }
		.RuleBlock { background-color:#EEEEFF; }
		.MessageNumber { font-family: Verdana; font-size: 10pt; color: darkred; }
		.MessageBlock { font-family: Verdana; font-size: 10pt; color: darkred; }
		.Resolution {font-family: Verdana; font-size: 8pt; color: black; }		
		.NodeLine { font-family: Verdana; font-size: 9pt;}
		.Note { font-family: Verdana; font-size: 9pt; color:black; background-color: #DDDDFF; }
		.NoteUser { font-family: Verdana; font-size: 9pt; font-weight: bold; }
		.NoteTime { font-family: Verdana; font-size: 8pt; font-style: italic; }
		.Button { font-family: Verdana; font-size: 9pt; color: blue; background-color: #EEEEEE; }
	</style>
	<script>
		function ViewState(blockId) {
			var block = document.getElementById(blockId);
			if (block.style.display=='none') {
				block.style.display='block';
			} else { 
				block.style.display='none';
			}
		}
		
		function SwitchAll(how) {			
			var nodes = document.getElementsByTagName("div");
			for (i = 0; i != nodes.length;i++) {	
				var block = nodes[i];
				if (block != null) {
					if(block.className == 'NodeDiv' || 
						block.className == 'MessageBlockDiv' ||
						block.className == 'MessageDiv') {
						block.style.display=how;
					}					
				}
			}
		}

		function ExpandAll() {
			SwitchAll('block');
		}
		
		function CollapseAll() {
			SwitchAll('none');
		}
	</script>
	<body bgcolor="white" alink="Black" vlink="Black" link="Black">
	<xsl:apply-templates select="$fxcop.root"/>

	</body>
	</html>
</xsl:template>

<xsl:template match="FxCopReport">
	<!-- Report Title -->
	<div id="Title">
		FxCop <xsl:value-of select="@Version"/> Analysis Report
	</div>
	<br/>
	<table>
		<tr>
			<td class="Button">
				<a onClick="ExpandAll();">Expand All</a>
			</td>
			<td class="Button">
				<a onClick="CollapseAll();">Collapse All</a>
			</td>
		</tr>
	</table>	
	<br/>
	<xsl:apply-templates select="Namespaces"/>
	<xsl:choose>
		<xsl:when test="Namespaces">
			<hr/>
		</xsl:when>
	</xsl:choose>
	<xsl:apply-templates select="Targets"/>
</xsl:template>

<xsl:template match="*">
<xsl:choose>
	<xsl:when test="@Name or name()='Resources'">
		<xsl:variable name="MessageCount" select="count(.//Message[@Status='Active'])"/>
		<xsl:choose>
			<xsl:when test="$MessageCount > 0">
				<xsl:variable name="nodeId" select="generate-id()"/>
				<div class="NodeLine">

					<xsl:attribute name="onClick">
						javascript:ViewState('<xsl:value-of select="$nodeId"/>');
					</xsl:attribute>
					
					<!-- Display Icon -->
					<xsl:choose>
						<xsl:when test="name()='Method'">
							<nobr class="NodeIcon">&#x0061;</nobr>	
						</xsl:when>
						<xsl:when test="name()='Constructor'">
							<nobr class="NodeIcon">&#x003D;</nobr>	
						</xsl:when>
						<xsl:when test="name()='Property'">
							<nobr class="NodeIcon">&#x0098;</nobr>	
						</xsl:when>
						<xsl:when test="name()='Event'">
							<nobr class="NodeIcon">&#x007E;</nobr>	
						</xsl:when>
						<xsl:when test="name()='Field'">
							<nobr class="NodeIcon">&#x00EB;</nobr>	
						</xsl:when>
						<xsl:when test="name()='Parameter'">
							<nobr class="NodeIcon">&#x0034;</nobr>	Parameter 
						</xsl:when>
						<xsl:when test="name()='Class'">
							<nobr class="NodeIcon">&#x003C;</nobr>	
						</xsl:when>
						<xsl:when test="name()='Interface'">
							<nobr class="NodeIcon">&#x003C;</nobr>	
						</xsl:when>
						<xsl:when test="name()='Delegate'">
							<nobr class="NodeIcon">&#x003C;</nobr>	
						</xsl:when>
						<xsl:when test="name()='Enum'">
							<nobr class="NodeIcon">&#x003C;</nobr>	
						</xsl:when>
						<xsl:when test="name()='ValueType'">
							<nobr class="NodeIcon">&#x003C;</nobr>	
						</xsl:when>
						<xsl:when test="name()='Namespace'">
							<nobr style="color: navy;">{} </nobr>	
						</xsl:when>
						<xsl:when test="name()='Target'">
							<nobr class="NodeIcon">&#x0032;</nobr>	
						</xsl:when>
						<xsl:when test="name()='Module'">
							<nobr class="NodeIcon">&#x0031;</nobr>	
						</xsl:when>
						<xsl:when test="name()='Resource'">
							<nobr class="NodeIcon">&#x009D;</nobr>	
						</xsl:when>
						<xsl:when test="name()='Resources'">
							<nobr class="NodeIcon">&#x00CC;</nobr>	
						</xsl:when>
						<xsl:otherwise>
							[<xsl:value-of select="name()"/>]	
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:choose>
						<xsl:when test="name()='Resources'">
							<xsl:value-of select="name()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@Name"/>
						</xsl:otherwise>
					</xsl:choose>
					<nobr class="MessageNumber">
						(<xsl:value-of select="$MessageCount"/>)
					</nobr>
				</div>
				
				<div class="NodeDiv" style="display: none; position: relative; padding-left: 11;">
					<xsl:attribute name="id">
						<xsl:value-of select="$nodeId"/>
					</xsl:attribute>

					<xsl:apply-templates />
				</div>

			</xsl:when>
		</xsl:choose>
	</xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates />
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="Messages">
	<xsl:variable name="MessageBlockId" select="generate-id()"/>		
	<div class="MessageBlock">
		<xsl:attribute name="onClick">
			javascript:ViewState('<xsl:value-of select="$MessageBlockId"/>');
		</xsl:attribute>
		<nobr class="MessagesIcon">&#x0040;</nobr>
		<xsl:variable name="MessageCount" select="count(Message[@Status='Active'])"/>
		<xsl:value-of select="$MessageCount"/>
			Message<xsl:choose><xsl:when test="$MessageCount > 1">s</xsl:when></xsl:choose>
			for 
			<xsl:choose><xsl:when test="name(..)='Parameter'">Parameter </xsl:when></xsl:choose>
			<xsl:value-of select="../@Name"/>
	</div>
	<div class="MessageBlockDiv" style="display: none; position: relative; padding-left: 5;">
		<xsl:attribute name="id">
			<xsl:value-of select="$MessageBlockId"/>
		</xsl:attribute>

		<table width="100%">
			<tr>
				<td class="ColumnHeader">Message Level</td>
				<td class="ColumnHeader">Certainty</td>
				<td class="ColumnHeader" width="100%">Resolution</td>
			</tr>
		<xsl:apply-templates select="Message[@Status='Active']"/>
		</table>
	</div>
		
</xsl:template>

<xsl:template match="Message">

	<!-- Message Row -->

	<xsl:variable name="messageId" select="generate-id()"/>
	<xsl:variable name="rulename" select="Rule/@TypeName"/>
	<xsl:variable name="level" select=".//@Level" />
	<xsl:variable name="certainty" select=".//@Certainty" />
	<xsl:variable name="resolution" select=".//Resolution/Text/text()" />

	<tr>
		<xsl:attribute name="onClick">
			javascript:ViewState('<xsl:value-of select="$messageId"/>');
		</xsl:attribute>

		<xsl:attribute name="bgcolor">
			<xsl:choose>
				<xsl:when test="position() mod 2 = 1">#EEEEEE</xsl:when>
				<xsl:otherwise>white</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<td valign="top">
			<xsl:attribute name="class"><xsl:value-of select="$level" /></xsl:attribute>
			<xsl:value-of select="$level" />
		</td>
		<td valign="top">
			<xsl:attribute name="class"><xsl:value-of select="$level" /></xsl:attribute>
			<xsl:value-of select="$certainty" />
		</td>
		<td class="Resolution" valign="top">
			<xsl:value-of select="$resolution" />
		</td>
	</tr>

	<tr>
		<td colspan="3">
			<div class="MessageDiv" style="display: none">
				<xsl:attribute name="id">
					<xsl:value-of select="$messageId"/>
				</xsl:attribute>

				<!--- Rule Details  -->
				<table width="100%" class="RuleBlock">
										<xsl:apply-templates select="Notes" mode="notes"/>
									<xsl:apply-templates select="SourceCode"/>
					<xsl:apply-templates select="/FxCopReport/Rules/Rule[@TypeName=$rulename]" mode="ruledetails" />
				</table>
			</div>
		</td>
	</tr>
</xsl:template>

<xsl:template match="Notes" mode="notes">
	<xsl:for-each select="Note">
		<xsl:variable name="id" select="@ID"/>
		<xsl:apply-templates select="/FxCopReport/Notes/Note[@ID=$id]" mode="notes"/>
	</xsl:for-each>
</xsl:template>

<xsl:template match="Note" mode="notes">
	<tr class="Note">
		<td colspan="3" class="Note">
		<nobr class="NoteUser"><xsl:value-of select="@UserName"/></nobr>
		&#160;		
		<nobr class="NoteTime">[<xsl:value-of select="@Modified"/>]</nobr>:
		<xsl:value-of select="."/>
		</td>		
	</tr>
</xsl:template>

<xsl:template match="SourceCode">
	<tr class="SourceCode">
		<td class="PropertyName">Source:</td>
		<td class="PropertyContent">
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="@Path"/>/<xsl:value-of select="@File"/>
				</xsl:attribute>
				<xsl:value-of select="@Path"/>/<xsl:value-of select="@File"/>
			</a>
			(Line <xsl:value-of select="@Line"/>)
		</td>
	</tr>
</xsl:template>

<xsl:template match="Description" mode="ruledetails">
	<tr>
		<td class="PropertyName">Rule Description:</td>
		<td class="PropertyContent"><xsl:value-of select="text()" /></td>
	</tr>	
</xsl:template>

<xsl:template match="LongDescription" mode="ruledetails">
	<!-- Test, don't display line if no data present -->
	<xsl:choose>
		<xsl:when test="text()">
			<tr>
				<td class="PropertyName">Long Description:</td>
				<td class="PropertyContent"><xsl:value-of select="text()" /></td>
			</tr>	
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="File" mode="ruledetails">
	<tr>
		<td class="PropertyName">Rule File:</td>
		<td class="PropertyContent"><xsl:value-of select="@Name"/> [<xsl:value-of select="@Version"/>]</td>
	</tr>	
</xsl:template>

<xsl:template match="Rule" mode="ruledetails">
	<tr>
		<td class="PropertyName">Rule:</td>
		<td class="PropertyContent"><xsl:value-of select="Name" /></td>
	</tr>	
	<xsl:apply-templates select="Description" mode="ruledetails" />
	<xsl:apply-templates select="LongDescription" mode="ruledetails" />
	<xsl:apply-templates select="File" mode="ruledetails" />
</xsl:template>

<!-- End Rule Details -->

</xsl:stylesheet>