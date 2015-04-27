<cfcomponent extends="frameworkone">
	
	<cfscript>
		//fw/1 settings
		variables.framework = {
			action="event",
			reload="init",
			password="666",
			home="bike.show",
			reloadApplicationOnEveryRequest=true
		};
		
		//cfapplication settings
		this.name = "myApplication";
		this.sessionManagement = true;
	</cfscript>
	
	<cffunction name="setupApplication" access="public" returntype="void" hint="Initialisiert die gesamte Applikation">
		<cfset setBeanFactory(createObject("component","framefactoryone").init(this))>
	</cffunction>
	
</cfcomponent>