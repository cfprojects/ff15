<cfparam name="local.marke"			default="" />
<cfparam name="local.typ"				default="#rc.typ#" />
<cfparam name="local.jahrgang"	default="#rc.jahrgang#" />
<cfparam name="local.error"			default="#structNew()#" />

<cfif structKeyExists(rc,"error")>
	<cfset local.marke		= rc.marke />
	<cfset local.typ			= rc.typ />
	<cfset local.jahrgang	= rc.jahrgang />
	<cfset local.error		= rc.error>
</cfif>

<cfoutput>
<cfif not structIsEmpty(local.error)>
	<p>
		Bei der Verarbeitung sind Fehler aufgetreten:
	</p>
	<cfdump var="#local.error#">
</cfif>
<form action="?event=bike.add" method="post">
	<p>
		marke *
		<input type="text" name="marke" id="marke" value="#local.marke#" />
	</p>
	<p>
		typ
		<input type="text" name="typ" id="typ" value="#local.typ#" />
	</p>
	<p>
		jahrgang
		<input type="text" name="jahrgang" id="jahrgang" value="#local.jahrgang#" />
	</p>
	<input type="submit" name="add" value="add" />
</form>
</cfoutput>