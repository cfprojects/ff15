<cfcomponent output="false" hint="Mein Motorrad">

<cfproperty name="marke"		required="true"		type="string" />
<cfproperty name="typ"			default="R6"			required="false"	type="string" />
<cfproperty name="jahrgang"	default="2010"		required="false"	type="numeric" />

<!--- add your functions, custom accessors or a customized validate function --->

</cfcomponent>