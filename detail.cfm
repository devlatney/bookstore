<cfinclude template="header.cfm"> 

<p>&nbsp;</p>

<div class="row">
<!--- <div class="col-md-4"> --->
<!--- <cfoutput> --->
<!---   <cfdump var="#form#">  --->
<!--- </cfoutput> --->
<!--- </div> --->
<div class="col-md-12">
<cfparam name="searchme" default=""> 
<cfquery name="bookinfo" datasource="#application.dsource#">
  select * from books
  left join publishers on books.publisher=publishers.publisherID
  where title like '%#trim(searchme)#%' or isbn13 like '%#trim(searchme)#%' 
</cfquery>
<cfoutput>
<cfif bookinfo.recordcount eq 0>
  #noResults()#
<cfelseif bookinfo.recordcount eq 1>
  #oneResult()# 
<cfelse>
  #manyResults()# 
</cfif>
</cfoutput>


</div>
<cfinclude template="footer.cfm"> 

<cffunction name="noResults">
  <cfoutput>
    There was no result to be found.
  </cfoutput>
</cffunction>

<cffunction name="oneResult">
  <cfoutput>
    <img src="images/#bookinfo.isbn13#.jpg" style="float:left; width:250px;"/> 
    <span>Description: #bookinfo.description[1]#</span>
  </cfoutput>
</cffunction>

<cffunction name="manyResults">
    <ol class="nav nav-stacked">
    <cfoutput query="bookinfo">
      <li><a href="#cgi.script_name#?p=details&searchme=#trim(isbn13)#">#trim(title)#</a></li>
    </cfoutput> 
    </ol> 
</cffunction>