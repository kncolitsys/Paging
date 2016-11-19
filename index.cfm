<cfparam name="session.MaxPages" default="6">
<cfparam name="session.MaxRows" default="24">
<cfparam name="session.startRow" default="1">
	
<CFQUERY NAME="getListings" DATASOURCE="MobilePlaylist">
    Select Title AS LocationName
    FROM songs
</CFQUERY>

<table border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<div style="padding-left:50px;">
				<div class="post">
					<h1 class="title">Paging Custom Tag</h1>
				</div>
				<div class="entry">
					<p>Classic Paging using Coldfusion<br>
						Features: plug and play just place it into any page and have your results become paged.<br>
						
						<strong>Attributes:</strong><br>
						
						Drop Down Page Select - Enable/Disable<br>
						
						First / Last Display - Enable/Disable<br>
						
						&gt; / &lt; Display - Enable/Disable<br>
						
						Total Results - Enable/Disable<br>
						
						Results per page: Enable/Disable and customize how many by default<br>
						
						Ability to control 'Show All results' - Enable/Disable and threshold for when activated<br>
						
						Append any string to each link automatically to maintain existing functionality<br>
						
						Four Themes to choose from: Subcide, Digg, Sproose &amp; Chow.
					</p>
				</div>	
			</div>			
		</td>
		<td>
			<table style="padding-left:50px;">				
				<tr>
					<td>
						Subcide
					</td>
				</tr>
				<tr>
					<td>
						<cfparam name="session.CurrentPage" default="1">
						<CF_ClassicPaging
								name="Pagination"
								MaxPages="#session.MaxPages#"
								MaxRows="#session.MaxRows#"
								queryName="getListings"
								<!--- Enter recordcount here, or qryObject above
								RecordCount="120" --->
								GotoPageEnable=True
								FirstLastEnable=True
								EnableArrows=True
								EnableSpeedArrows=True
								EnableRecordCount=True
								ResultsPerPageEnable=True
								EnablePages=True
								EnableAllResults=True
								<!--- This is the threshold the recordcount must meet or exceed before the EnableAllResults is activated, blank will always show --->
								AllResultsThreshold="100"
								<!--- use leading ampersand &QueryString --->
								StringAppend=""
								<!--- leave blank for default, or comma list for custom --->
								PageSelect="6,12,24,48,36"
								Mode="Numeric"
								Theme="Subcide"
							>
					</td>
				</tr>
				<tr>
					<td>
						Digg
					</td>
				</tr>
				<tr>
					<td>
						<cfparam name="session.CurrentPage" default="1">
						<CF_ClassicPaging
								name="Pagination"
								MaxPages="#session.MaxPages#"
								MaxRows="#session.MaxRows#"
								queryName="getListings"
								GotoPageEnable="TRUE"
								FirstLastEnable="TRUE"
								EnableArrows="FALSE"
								EnableRecordCount="TRUE"
								ResultsPerPageEnable="TRUE"
								EnablePages="TRUE"
								EnableAllResults=TRUE
								<!--- This is the threshold the recordcount must meet or exceed before the EnableAllResults is activated, blank will always show --->
								AllResultsThreshold="202"
								<!--- use leading ampersand &QueryString --->
								StringAppend=""
								Theme="Digg"
							>
					</td>
				</tr>
				<tr>
					<td>
						Sproose
					</td>
				</tr>
				<tr>
					<td>
						<cfparam name="session.CurrentPage" default="1">
						<CF_ClassicPaging
								name="Pagination"
								MaxPages="#session.MaxPages#"
								MaxRows="#session.MaxRows#"
								queryName="getListings"
								GotoPageEnable="TRUE"
								FirstLastEnable="TRUE"
								EnableArrows="TRUE"
								EnableSpeedArrows=False
								EnableRecordCount="TRUE"
								ResultsPerPageEnable="TRUE"
								EnablePages="TRUE"
								EnableAllResults=TRUE
								<!--- This is the threshold the recordcount must meet or exceed before the EnableAllResults is activated, blank will always show --->
								AllResultsThreshold="100"
								<!--- use leading ampersand &QueryString --->
								StringAppend=""
								Theme="Sproose"
							>
					</td>
				</tr>		
					<tr>
					<td>
						Chow
					</td>
				</tr>
				<tr>
					<td>
						<cfparam name="session.CurrentPage" default="1">
						<CF_ClassicPaging
								name="Pagination"
								MaxPages="#session.MaxPages#"
								MaxRows="#session.MaxRows#"
								queryName="getListings"
								GotoPageEnable="TRUE"
								FirstLastEnable="TRUE"
								EnableArrows="TRUE"
								EnableRecordCount="TRUE"
								ResultsPerPageEnable="TRUE"
								EnablePages="TRUE"
								EnableAllResults=FALSE
								<!--- This is the threshold the recordcount must meet or exceed before the EnableAllResults is activated, blank will always show --->
								AllResultsThreshold="100"
								<!--- use leading ampersand &QueryString --->
								StringAppend=""
								Theme="miniChow"
							>
					</td>
				</tr>
				<cfoutput query="getListings" maxrows="#session.MaxRows#" startrow="#session.StartRow#">
					<tr>
						<td>
							#CurrentRow#. #LocationName#<br>
						</td>
					</tr>
				</cfoutput>
			</table>		
		</td>
	</tr>
</table>

<div>
					<pre>
							Usage
							CF_ClassicPaging
								name="Pagination" <- Leave alone
								MaxPages="#session.MaxPages#" <- Leave alone
								MaxRows="#session.MaxRows#" <- Leave alone
								queryName="getListings" <- Use query object
								RecordCount="120" <- or use the query.recordcount instead (one or the other)
								GotoPageEnable=True <- drop down to navigate to directly to a page
								ResultsPerPageEnable=True <- drop down to select how many per page
								FirstLastEnable=True <- enable or disable the buttons that say 'first' and 'last'
								EnableArrows=True <- enable or disable the single &gt;,&lt; arrows
								EnableSpeedArrows=True <- enable or disable the &gt;&gt; speed arrows to navigate using arrows faster
								EnableRecordCount=True <- enable or disable the '200 Results' button
								EnableAllResults=True <- enable or disable the 'Show All Results'
								AllResultsThreshold="100" <- disable the 'Show All Results' based on a given threshold
								EnablePages=True <- enable or disable the [1][2][3][4][5] Paging 
								StringAppend="" <- use leading ampersand &QueryString to support existing code that depends on url variables
								PageSelect="6,12,24,48,36" <- leave blank for default 5,10,15,30 results per page, or comma delimeted list for custom
								Mode="Numeric" <- show [1][2][3][4][5] or [1-5][6-10] etc.
								Theme="Subcide" <-Theme to pick avaiabile are Sproose, Chow, Subcide, Digg, miniChow
											
					</pre>
</div>

<!-- Start of StatCounter Code -->
<script type="text/javascript">
sc_project=1087187; 
sc_invisible=1; 
sc_partition=9; 
sc_security="cbef3684"; 
</script>

<script type="text/javascript"
src="http://www.statcounter.com/counter/counter.js"></script><noscript><div
class="statcounter"><a title="web statistics"
href="http://www.statcounter.com/free_web_stats.html"
target="_blank"><img class="statcounter"
src="http://c10.statcounter.com/1087187/0/cbef3684/1/"
alt="web statistics" ></a></div></noscript>
<!-- End of StatCounter Code -->

