<cfcomponent output="false" hint="Enthaelt die User Eigenschaften inklusive dynamischen Accessors">
	
<cfproperty name="username"		type="string"	required="true"	hint="Name des Benutzers" />
<cfproperty name="password"		type="string"	required="true"	hint="Passwort des Benutzers" />
<cfproperty name="birthdate"	type="date"		required="true"	hint="Geburtsdatum des Benutzers" />

<!--- add your functions, custom accessors or a customized validate function --->

</cfcomponent>