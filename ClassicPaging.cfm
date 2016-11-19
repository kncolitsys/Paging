	<style>
		<cfinclude template="paging.css">
	</style>

	<!--- Change Log v1.5
	improved the show all code, now ready, added numeric paging and fixed some other bugs
	added the showall code still working on it
	Added the title results for hover pages
	fixed a bug in the maxpages code
	Added String Append,
	SpeedArrows are still in beta!
	fixed an error with search results in url strings not retaining the maxrows
	 --->
	 	<!--- This Part Checks for priorities like URL scope is more important than attributes scope,
	and then finally the cfparam takes least priority --->
	<cfif not(isDefined('attributes.recordCount'))>
		<cfset RecordCount = Ceiling(#Evaluate("caller.#attributes.queryName#.recordCount")#)>
	<cfelse>
		<cfset RecordCount = Ceiling(Attributes.RecordCount)>	
	</cfif>
	<cfparam name="session.showAll" default="FALSE">
	<cfparam name="CurrentPage" default="1">
	<cfif isDefined("url.CurrentPage") AND url.CurrentPage NEQ "">
		<cfset session.CurrentPage = url.CurrentPage>
		<cfset CurrentPage = url.CurrentPage>
	</cfif>
	<cfparam name="attributes.mode" default="classic">
	<cfparam name="mode" default="#attributes.mode#">
	<cfparam name="Attributes.EnableAllResults" default="FALSE">
	<cfparam name="Attributes.AllResultsThreshold" default="">
	<cfparam name="Attributes.PageSelect" default="">
	<!--- Defines the order of the paging, whether to show all, to show pages, or to show all depending on the threshold of results returned --->
	<cfif (Attributes.EnableAllResults EQ TRUE AND RecordCount LTE Attributes.AllResultsThreshold) OR (Attributes.AllResultsThreshold EQ "")>
		<cfset session.EnableAllResults = TRUE> 
		<cfif (isDefined("url.ShowAll") AND URL.ShowAll EQ TRUE)>
			<cfset session.ShowAll = TRUE>
			<cfset session.MaxRows = RecordCount>
		<cfelseif (isDefined("url.ShowAll") AND URL.ShowAll EQ FALSE)>
			<cfset session.ShowAll = FALSE>
			<cfset session.MaxRows = attributes.MaxRows>	
		<cfelse>
			<!--- <cfset session.ShowAll = FALSE> --->
			<!--- Normal Paging --->	
			<cfif isDefined("url.MaxRows") AND url.MaxRows NEQ "">
				<cfset session.MaxRows = url.MaxRows>
			<cfelseif isDefined("session.MaxRows") AND session.MaxRows NEQ "">
				<cfset session.MaxRows = session.MaxRows>
			<cfelseif isDefined("attributes.MaxRows") AND attributes.MaxRows NEQ "">
				<cfset session.MaxRows = attributes.MaxRows>
			</cfif>				
		</cfif>
	<cfelse> <!---Doesn't matter if its False or Not defined its not TRUE if (isDefined("Attributes.EnableAllResults") AND Attributes.EnableAllResults EQ False) --->
		<!--- default to normal paging and disable the showall feature --->
		<cfset session.EnableAllResults = False>
		<cfset session.ShowAll = FALSE>
		<!--- Normal Paging --->	
		<cfif isDefined("url.MaxRows") AND url.MaxRows NEQ "">
			<cfset session.MaxRows = url.MaxRows>
		<cfelseif isDefined("session.MaxRows") AND session.MaxRows NEQ "">
			<cfset session.MaxRows = session.MaxRows>
		<cfelseif isDefined("attributes.MaxRows") AND attributes.MaxRows NEQ "">
			<cfset session.MaxRows = attributes.MaxRows>
		</cfif>	
	</cfif>			
		
		<cfset NumberOfPages = Ceiling(RecordCount / session.MaxRows)>
		<cfset currentPage = iif((NumberOfPages GT CurrentPage),DE(CurrentPage),DE(NumberOfPages))>

	<cfif isDefined("attributes.StringAppend") AND attributes.StringAppend NEQ "">
		<cfset session.StringAppend = attributes.StringAppend>
	<cfelse>
		<cfset session.StringAppend = "">
	</cfif>

	<cfif isDefined("url.theme") AND url.theme NEQ "">
		<cfset session.theme = url.theme>
		<cfset theme = url.theme>
		<cfset attributes.theme = url.theme>
	</cfif>
	<!--- Original Default visit Sproose.com, Chow.com, Digg.Com, Subcide.com for a visual example--->
	<cfparam name="attributes.Theme" default="Sproose">
	<!--- blue & white --->
	<cfif attributes.theme EQ "Sproose">
		<cfset CSSTheme = "paging">
	<!--- grey & white --->
	<cfelseif attributes.theme EQ "Chow">
		<cfset CSSTheme = "paging2">
	<!--- blue & white small --->
	<cfelseif attributes.theme EQ "Digg">
		<cfset CSSTheme = "paging3">
	<!---  Black & Orange--->
	<cfelseif attributes.theme EQ "Subcide">
		<cfset CSSTheme = "paging4">
	<!---  Black & Orange--->
	<cfelseif attributes.theme EQ "miniChow">
		<cfset CSSTheme = "paging5">	
	<cfelse>
		<cfset CSSTheme = "paging">
		**Theme Name Not Found Reverting to Default**	
	</cfif>
	<!--- Max [1][2][3] Blocks Per Page --->
	<cfparam name="MaxPages" default="5">
	<cfset MaxPages = attributes.MaxPages>
	<!--- Max Rows of Information Per Page --->
	<cfparam name="session.MaxRows" default="5">

	<cfparam name="queryName" default="GetListings">
	<!--- Drop Down Pages --->
	<cfparam name="Attributes.GotoPageEnable" default="TRUE">
	<!--- Enable First and Last button on the edges --->
	<cfparam name="Attributes.FirstLastEnable" default="TRUE">
	<!--- Enable the > and < Arrows --->
	<cfparam name="Attributes.EnableArrows" default="TRUE">
	<!--- Enable the >> AND << arrows --->
	<cfparam name="Attributes.EnableSpeedArrows" default="TRUE">
	<!--- Enable total amount of results --->
	<cfparam name="Attributes.EnableRecordCount" default="TRUE">
	<!--- Trickiest still beta code enable Amount of Rows per page --->
	<cfparam name="Attributes.ResultsPerPageEnable" default="TRUE">
	<!--- Enable [1][2][3] Blocks --->
	<cfparam name="Attributes.EnablePages" default="TRUE">
	<cfset session.StartRow = (session.MaxRows * CurrentPage) - (session.MaxRows - 1)>
	<cfset NumberOfPages = Ceiling(RecordCount / session.MaxRows)>
	<cfif NumberOfPages LTE MaxPages>
		<cfset CurrentMaxPages = NumberOfPages>
	<cfelseif NumberOfPages GT MaxPages>
		<cfset CurrentMaxPages = MaxPages>
	</cfif>
	<cfoutput>
	<div id="#CSSTheme#" style="text-align: right;">
			<cfif Attributes.EnableRecordCount>
				<!--- Show RecordCount --->
				<div id="divResults" class="page disabled" <cfif session.EnableAllResults>onclick="location.href='?ShowAll=#iif((session.ShowAll EQ TRUE),DE('False'),DE('True'))##session.StringAppend#'" 
				onmouseover="this.innerHTML = 'Show #iif((session.ShowAll EQ TRUE),DE('Pages'),DE('All Results'))#';" 
				onmouseout="this.innerHTML = '#RecordCount# Results';"</cfif>>
					#RecordCount# Results
				</div>
			</cfif>
			<cfif Attributes.FirstLastEnable>
				<!--- Show first --->
				<cfif CurrentPage NEQ 1>
						<div class="page" onclick="location.href='?CurrentPage=1#session.StringAppend#'">
							First
						</div>
				</cfif>
			</cfif>
			<cfif Attributes.EnableSpeedArrows>
				<cfif CurrentPage GT CurrentMaxPages>
					<div title="Go to page #(CurrentPage - (CurrentMaxPages - 1))* -1#" class="page" onclick="location.href='?CurrentPage=#(CurrentPage - (CurrentMaxPages - 1))* -1##session.StringAppend#'">
						&lt;&lt;
					</div>
				</cfif>
			</cfif>			
			<cfif Attributes.EnablePages EQ False AND Attributes.EnableArrows EQ True>
					<div  title="Go to page #CurrentPage - iif((CurrentPage EQ 1),DE('0'),DE('1'))#" class="page" onclick="location.href='?CurrentPage=#CurrentPage - iif((CurrentPage EQ 1),DE('0'),DE('1'))##session.StringAppend#'">
						&lt;
					</div>
			<cfelseif Attributes.EnableArrows>
				<!--- Code For Arrows --->
				<cfif CurrentPage NEQ 1>
					<div  title="Go to page #CurrentPage - 1#" class="page" onclick="location.href='?CurrentPage=#CurrentPage - 1##session.StringAppend#'">
						&lt;
					</div>
				</cfif>
			</cfif>
			<cfif Attributes.EnablePages>
				<!--- Code for First Set of Pages --->
				<cfif CurrentPage LTE MaxPages>
					<cfloop from="1" to="#CurrentMaxPages#" index="iLoop">
						<cfset curResultSet = "#(iLoop * session.MaxRows) - (session.MaxRows - 1)#-#(iLoop * session.MaxRows) - (((iLoop * session.MaxRows) mod RecordCount) mod (iLoop * session.MaxRows))#">
						<div title="Results #curResultSet#"
							id="page#iLoop#" class="page#iif((iLoop EQ CurrentPage),DE(' active'),DE(''))#"
							onclick="location.href='?CurrentPage=#iLoop##session.StringAppend#'">
							<cfif isDefined('Mode') AND Mode EQ "Numeric">
								#curResultSet#
							<cfelse>
								#iLoop#	
							</cfif>
						</div>
					</cfloop>
				<!--- Code for last set of pages--->
				<cfelseif CurrentPage EQ NumberOfPages OR (CurrentPage GTE NumberOfPages - (NumberOfPages mod MaxPages) AND CurrentPage LT NumberOfPages)>
					<cfloop from="#CurrentPage - (CurrentPage MOD MaxPages)#" to="#NumberOfPages#" index="iLoop">
						<cfset curResultSet = "#(iLoop * session.MaxRows) - (session.MaxRows - 1)#-#(iLoop * session.MaxRows) - (((iLoop * session.MaxRows) mod RecordCount) mod (iLoop * session.MaxRows))#">
						<div title="Results #curResultSet#"
							class="page#iif((iLoop EQ CurrentPage),DE(' active'),DE(''))#" onclick="location.href='?CurrentPage=#iLoop##session.StringAppend#'">
							<cfif isDefined('Mode') AND Mode EQ "Numeric">
								#curResultSet#
							<cfelse>
								#iLoop#	
							</cfif>
						</div>
					</cfloop>
				<!--- code for all other pages --->
				<cfelse>
					<cfloop from="#CurrentPage - (CurrentPage MOD MaxPages)#" to="#((CurrentPage + MaxPages) - 1) - (CurrentPage MOD MaxPages)#" index="iLoop">
						<cfset curResultSet = "#(iLoop * session.MaxRows) - (session.MaxRows - 1)#-#(iLoop * session.MaxRows) - (((iLoop * session.MaxRows) mod RecordCount) mod (iLoop * session.MaxRows))#">
						<div title="Results #curResultSet#"
							class="page#iif((iLoop EQ CurrentPage),DE(' active'),DE(''))#" onclick="location.href='?CurrentPage=#iLoop##session.StringAppend#'">
							<cfif isDefined('Mode') AND Mode EQ "Numeric">
								#curResultSet#
							<cfelse>
								#iLoop#	
							</cfif>
						</div>
					</cfloop>
				</cfif>
			</cfif>
			<cfif Attributes.EnableArrows>
				<!--- Code For Arrows --->
				<cfif CurrentPage LT NumberOfPages AND CurrentPage LTE CurrentPage + MaxPages>
					<div  title="Go to page #CurrentPage + 1#"  class="page" onclick="location.href='?CurrentPage=#CurrentPage + 1##session.StringAppend#'">
						&gt;
					</div>
				</cfif>
			</cfif>
			<cfif Attributes.EnableSpeedArrows>
				<!--- Code For Arrows ---><!--- CurrentPage + (CurrentMaxPages - 1) --->
				<cfif CurrentPage LT NumberOfPages AND CurrentPage LTE CurrentPage + MaxPages> 
					<div  title="Go to page #((CurrentPage + MaxPages) - 1) - ((NumberOfPages mod MaxPages) mod CurrentPage)#"  class="page" onclick="location.href='?CurrentPage=#((CurrentPage + MaxPages) - 1) - ((NumberOfPages mod MaxPages) mod CurrentPage)##session.StringAppend#'">
						&gt;&gt;
					</div>
				</cfif>
			</cfif>
			<cfif Attributes.FirstLastEnable>
				<cfif CurrentPage NEQ NumberOfPages>
						<div title="Go to page #NumberOfPages#"  class="page disabled" onclick="location.href='?CurrentPage=#NumberOfPages##session.StringAppend#'">
							Last
						</div>
				</cfif>
			</cfif>
			<cfif Attributes.GotoPageEnable AND session.ShowALL EQ FALSE>
				<div class="GotoPage">
					<label for="SelectPage">Page <select class="PageSelect" name="SelectPage" id="SelectPage" onfocus="document.getElementById('SelectPage').click();" onchange="location.href='?CurrentPage=' + this.value + '#session.StringAppend#';">
							<cfloop from="1" to="#NumberOfPages#" index="iLoop">
								<option #iif((iLoop EQ CurrentPage),DE('selected'),DE(''))# value="#iLoop#">#iLoop#</option>
							</cfloop>
						</select></label>
				</div>
			</cfif>
			<cfif Attributes.ResultsPerPageEnable AND session.ShowALL EQ FALSE>
				<div class="GotoPage">
					<!--- Max Results  --->
					<select class="PageSelect" name="SelectPage" onchange="location.href='?CurrentPage=#CurrentPage#&MaxRows=' + this.value + '#session.StringAppend#';">
						<cfif attributes.PageSelect EQ "">
								<option #iif((session.MaxRows EQ 5),DE('selected'),DE(''))#  value="5">5 Per Page</option>
							<cfloop from="10" to="50" step="10" index="iLoop">
								<option #iif((iLoop EQ session.MaxRows),DE('selected'),DE(''))# value="#iLoop#">#iLoop# Per Page</option>
							</cfloop>
						<cfelse>
							<cfloop from="1" to="#ListLen(attributes.PageSelect)#" index="i">
								<cfset curRow = ListGetAt(attributes.PageSelect,i)>
								<option #iif((curRow EQ session.MaxRows),DE('selected'),DE(''))# value="#curRow#">#curRow# Per Page</option>
							</cfloop>
						</cfif>	
					</select>
				</div>
			</cfif>
	</div>
	</cfoutput>
