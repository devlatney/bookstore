<cfinclude template="../header.cfm">
<cfparam name="book" default="">
<cfparam name="qterm" default="">

<script>
    function togglenewisbnform(){
        var newISBNArea=document.getElementById('newisbn13area'); 
        if(newISBNArea.style.display=='none'){
            newISBNArea.style.display='inline';
        } else {
            newISBNArea.style.display='none'
        }
    } 
</script>


<cftry>
    <p>&nbsp;</p>
    <div class="row">
        <div id="leftgutter" class="col-md-4">
            <cfset processForms()>
            <div><h3>Book List</h3></div>
            <cfoutput>#sideNav()#</cfoutput>
        </div>
        <div id="main" class="col-md-8 pull-right">
             <cfoutput>#mainForm()#</cfoutput> 
        </div>
    </div>
    <cfcatch type="any">
        <cfoutput>
            #cfcatch.Message#
        </cfoutput>
    </cfcatch>
</cftry> 
 
<cffunction name="mainForm">
    <cfif book neq "">
        <cfquery name="thisbook" datasource="#application.dsource#">
            select * from books where isbn13='#book#'
        </cfquery> 
        <cfoutput>
        <form action="#cgi.script_name#?tool=addedit" method="post" class="form-horizontal">
            <input type="hidden" name="qterm" value="#qterm#" /> 
            <div class="form-group">
                <label for="isbn13" class="col-lg-3 control-label">ISBN13:</label>
                <div class="col-lg-9">
<!---                     <input type="text" id="isbn13" name="isbn13" value="#thisbook.ISBN13#" placeholder="ISBN13" /> --->
                        <cfset isbnfield="none">
                        <cfset isbndisplay="inline">
                        <cfset req=''> 
                        <cfif trim(thisbook.isbn13[1]) eq ''>
                            <cfset isbnfield="inline">
                            <cfset isbndisplay="none">
                            <cfset req="required">
                        </cfif> 
                        <span id="newisbn13area" style="display:#isbnfield#">
                            <input id="newisbn13" class="form-control" type="text" name="newisbn13" value="# thisbook.isbn13[1]#" 
                            placeholder="Put the ISBN13 code here" #req#  pattern=".{13}" title="Please Enter 13 characters only please. No dashes necessary" >
                        </span>
                        <span style="display:#isbndisplay#">
                        # thisbook.isbn13[1]# 
                        <input type="hidden" class="form-control" id="isbn13" name="isbn13" 
                        placeholder="ISBN13" value="#thisbook.isbn13[1]#" /> 
                        <button type="button" onclick="togglenewisbnform()" class="btn btn-warning btn-xs">Edit ISBN</button> 
                        </span> 
                </div>
                <div class="form-group">
                    <label for="title" class="col-lg-3 control-label">Title</label>
                    <div class="col-lg-9">
                        <input type="text" class="form-control" id="title" name="title" value="#thisbook.title#" placeholder="Book Title" required maxlength="45"/>
                    </div>
                </div>
                <div class="form-group">
                    <label for="year" class="col-lg-3 control-label">Year</label>
                    <div class="col-lg-9">
                        <input type="text" class="form-control" id="year" name="year" value="#thisbook.year#" placeholder="Year" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="weight" class="col-lg-3 control-label">Weight</label>
                    <div class="col-lg-9">
                        <input type="text" class="form-control" id="weight" name="weight" value="#thisbook.weight#" placeholder="Book Weight (lbs)" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="isbn" class="col-lg-3 control-label">ISBN</label>
                    <div class="col-lg-9">
                        <input type="text" class="form-control" id="isbn" name="isbn" value="#thisbook.isbn#" placeholder="ISBN" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="pages" class="col-lg-3 control-label">Pages</label>
                    <div class="col-lg-9">
                        <input type="text" class="form-control" id="pages" name="pages" value="#thisbook.pages#" placeholder="No of Pages" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="description" class="col-lg-3 control-label">Description</label>
                    <div class="col-lg-9">
                        <textarea id="bookdesc" name="description">#trim(thisbook.description[1])#</textarea>
                        <script>
                            CKEDITOR.replace('bookdesc'); 
                        </script> 
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Add Book</button> 
            </div>
        </form>
        </cfoutput>
    </cfif>
</cffunction> 
 
<cffunction name="sideNav">
    <cfoutput>
        <form action="#cgi.SCRIPT_NAME#?tool=addedit" method="post" class="form-inline">
        <div class="form-group">
            <input type="text" class="form-control" id="qterm" name="qterm" value="#qterm#"> 
            <button type="submit" class="btn btn-xs btn-primary">Search</button> 
        </div> 
        </form> 
    </cfoutput> 
    <cfif qterm neq "">
        <cfquery name="allBooks" datasource="#application.dsource#">
            select * from books where title like '%#qterm#%' order by title
        </cfquery> 
   
        <div>
            <ul class="nav nav‐stacked">
                <cfoutput>
                    <li><a href="#cgi.script_name#?tool=addedit&book=new&qterm=#qterm#">Add a Book</a></li>
                </cfoutput>
                <cfoutput query="allBooks">
                    <li><a href="#cgi.script_name#?tool=addedit&book=#isbn13#&qterm=#qterm#">#title#</a></li>
                </cfoutput>
                </ul>
        </div>
    <cfelse>
        No Search Term Entered (Try *and*)
    </cfif> 
    
    
 </cffunction>

<cffunction name="processForms">
    <cfif isdefined('form.isbn13')>
        <cfquery name="adddata" datasource="#application.dsource#">
            If not exists(select * from books where isbn13='#form.isbn13#')
            insert into books (isbn13,title) values ('#form.isbn13#','#form.title#');
            update books set
            title='#form.title#',
            weight='#form.weight#',
            year='#form.year#',
            isbn='#form.isbn#',
            pages='#form.pages#',
            description='#form.description#'
            where isbn13='#form.isbn13#'
        </cfquery> 
    </cfif>
    <cfif isdefined('form.newisbn13')>
        <cfquery datasource='#application.dsource#'>
            update books set isbn13='#form.newisbn13#' where isbn13='#form.isbn13#'
        </cfquery>
        <cfset form.isbn13=form.newisbn13>
    </cfif> 
</cffunction> 
 
 <cfinclude  template="../footer.cfm">