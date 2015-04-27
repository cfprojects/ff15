<cfcomponent output="false" hint="Service für einen Bike Request">

<cffunction name="add" returntype="struct" access="public" output="false" hint="Print Request">
	<cfargument name="marke"	type="string"		required="true" hint="Marke des Motorrads" />
	<cfargument name="typ"		type="string"		required="false" hint="Typ des Motorrads" />
	<cfargument name="jahrgang"	type="string"	required="false" default="" hint="Baujahr des Motorrads" />
	
	<!--- get your model and add the bike --->
	<cfset createModel("bike").add(argumentCollection=arguments) />

	<cfreturn arguments />
</cffunction>

</cfcomponent>