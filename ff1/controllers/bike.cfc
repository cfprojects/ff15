<cfcomponent output="false" hint="Controller fuer einen Motorrad Request">

<cffunction name="init" returntype="any" access="public" output="false" hint="Laedt das Framework One">
	<cfargument name="fw" type="any" required="true" hint="Framework One Objekt" />
	
	<cfset variables.fw = arguments.fw />
	
	<cfreturn this />
</cffunction>


<cffunction name="startShow" returntype="struct" access="public" output="false" hint="Motorrad Ausgeben">
	<cfargument name="rc" type="struct" required="true" hint="Request Context" />
	
	<cfset var local = structNew() />
	<cfset local.bike				= createBean("bike") />
	<cfset local.attributes	= local.bike.getInstance() />
	
	<cfloop collection="#local.attributes#" item="local.attribute">
		<cfif structKeyExists(local.attributes[local.attribute],"default")>
			<cfparam name="rc.#local.attribute#" default="#local.attributes[local.attribute].default#" />
		</cfif>
	</cfloop>
	
	<cfreturn rc />
</cffunction>


<cffunction name="add" returntype="struct" access="public" output="false" hint="Motorrad hinzufuegen">
	<cfargument name="rc" type="struct" required="true" hint="Request Context" />
	<!---
	
	complete example:
	
	<cfset var bike = createBean("bike") />
	<cfset variables.fw.validateBean(bike) />
	
	the short way:
	
	<cfset var bike = variables.fw.validateBean(createBean("bike")) />
	
	--->
	<cfset var local = structNew() />
	<cfset local.bike = variables.fw.validateBean(bean=createBean("bike")) />

	<cfif not local.bike.isValid()>
		<cfset rc.error = local.bike.getErrors() />
		<cfset variables.fw.redirect("bike.show",structKeyList(rc)) />
	</cfif>
	
	<cfset local.attributes = local.bike.getInstance() />
	
	<cfloop collection="#local.attributes#" item="local.attribute">
		<cfset rc[local.attribute] = local.attributes[local.attribute].value />
	</cfloop>
	
	<cfreturn rc />
</cffunction>
	
</cfcomponent>