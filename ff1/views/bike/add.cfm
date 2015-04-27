<cfparam name="local.marke"		default="" />
<cfparam name="local.typ"			default="" />
<cfparam name="local.jahrgang"	default="" />

<cfif structKeyExists(rc,"data")>
	<cfset local.marke		= rc.data.marke />
	<cfset local.typ			= rc.data.typ />
	<cfset local.jahrgang	= rc.data.jahrgang />
</cfif>

<cfoutput>
<p>
	Motorrad hinzugef&uuml;gt!
</p>
<p>
	Marke: #local.marke#<br />
	Typ: #local.typ#<br />
	Jahrgang: #local.jahrgang#
</p>
</cfoutput>