<cfcomponent output="false" hint="Usermodel uebernimmt alle CRUD Arbeiten fuer den User">
	
<cffunction name="save" returntype="void" access="public" output="false" hint="Speichert den User in der Datenbank">
	<cfargument name="username"		type="string" required="true" hint="Name des Benutzers" />
	<cfargument name="password"		type="string" required="true" hint="Passwort des Benutzers" />
	<cfargument name="birthdate"	type="string" required="true" hint="Geburtsdatum des Benutzers" />

	<cfset var local = structNew() />

	<cfquery name="local.myQuery" datasource="#variables.instance.datasource#">
		<!--- your insert statement --->
	</cfquery>
</cffunction>

</cfcomponent>