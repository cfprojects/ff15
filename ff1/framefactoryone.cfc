<cfcomponent output="false" hint="Framefactory One fuer Framework One">

<cffunction name="init" returntype="any" access="public" output="false" hint="Initialisiert alle Objekte">
	<cfargument name="fw" type="any" required="yes" hint="Framework One Objekt" />
	<cfscript>
		variables.fw = arguments.fw;
		variables.fw.functionInjectionHelper = functionInjectionHelper;
		variables.fw.functionInjectionHelper("validateBean", frameworkValidateBean);
		structDelete(variables.fw,"functionInjectionHelper");
				
		variables.base = getDirectoryFromPath(cgi.script_name);
		
		variables.instance = structNew();
		variables.instance.objects = structNew();
		
		buildObjects();
		
		return this;
	</cfscript>
</cffunction>


<cffunction name="getBean" returntype="any" access="public" output="false" hint="Liefert ein bestimmtes Objekt zurueck das initialisiert wurde">
	<cfargument name="name" type="string" required="true" hint="Name des Objekts" />
	
	<cfreturn variables.instance.objects[arguments.name] />
</cffunction>


<cffunction name="containsBean" returntype="boolean" access="public" output="false" hint="Prueft ob ein bestimmtes Objekt initialisiert wurde">
	<cfargument name="name" type="string" required="true" hint="Name des Objekts" />
	
	<cfreturn structKeyExists(variables.instance.objects,arguments.name) />
</cffunction>


<cffunction name="loadedBeans" returntype="string" access="public" output="false" hint="Gibt eine Liste aller geladenen Objekte zurueck">
	
	<cfreturn structKeyList(variables.instance.objects) />
</cffunction>


<cffunction name="buildObjects" returntype="void" access="private" output="false" hint="Laedt alle Objekte">
	<cfset var local = structNew() />
	<cfset local.types = "bean,model,controller,service" />
	
	<cfloop list="#local.types#" index="local.type">
		<cfset local.relDir		= "#variables.base##local.type#s" />
		<cfset local.absDir	= expandPath(local.relDir) />
		<cfif directoryExists(local.absDir)>
			<cfdirectory action="list" name="local.objects" directory="#local.absDir#" filter="*.cfc" />
			<cfloop query="local.objects">
				<cfset local.object = listFirst(local.objects.name[local.objects.currentRow],".") />
				<cfset loadObject(cfc="#local.relDir#/#local.object#", name="#local.object##local.type#", type=local.type) />
				<cfset initObject(name="#local.object##local.type#", type=local.type) />
			</cfloop>
		</cfif>
	</cfloop>
</cffunction>


<cffunction name="loadObject" returntype="void" access="private" output="false" hint="Laedt ein Objekt">
	<cfargument name="cfc"		type="string" required="true" hint="Pfad zum Objekt" />
	<cfargument name="name"	type="string" required="true" hint="Name des Objekts" />
	<cfargument name="type"	type="string" required="true" hint="Typ des Objekts (bean,controller,model,service)" />
	
	<cfset var local = structNew() />
	<cfset local.typeLen = len(arguments.type) />
	
	<cfif not structKeyExists(variables.instance.objects,arguments.name)>
		<cfset variables.instance.objects[arguments.name] = createObject("component",arguments.cfc) />
		
		<cfset local.factoryMethods = structNew() />
		<cfset local.objectMethods = structNew() />
		
		<cfloop collection="#variables#" item="local.factoryMethod">
			<cfif len(local.factoryMethod) gt 6 and not compareNoCase("object",left(local.factoryMethod,6))>
				<cfset local.factoryMethods[right(local.factoryMethod,len(local.factoryMethod) - 6)] = local.factoryMethod />
			<cfelseif len(local.factoryMethod) gt local.typeLen and not compareNoCase(arguments.type,left(local.factoryMethod,local.typeLen))>
					<cfset local.objectMethods[right(local.factoryMethod,len(local.factoryMethod) - local.typeLen)] = local.factoryMethod />
			</cfif>
		</cfloop>
		
		<cfset structAppend(local.factoryMethods,local.objectMethods,true) />
		
		<cfset variables.instance.objects[arguments.name].functionInjectionHelper = functionInjectionHelper />
		<cfloop collection="#local.factoryMethods#" item="local.objectMethod">
			<cfset variables.instance.objects[arguments.name].functionInjectionHelper(local.objectMethod,variables[local.factoryMethods[local.objectMethod]]) />
		</cfloop>
		<cfset structDelete(variables.instance.objects[arguments.name],"functionInjectionHelper") />
	</cfif>

</cffunction>


<cffunction name="initObject" returntype="void" access="private" output="false" hint="Initialisiert ein Objekt">
	<cfargument name="name"	type="string" required="true" hint="Name des Objekts" />
	<cfargument name="type"	type="string" required="true" hint="Typ des Objekts (bean,controller,model,service)" />
	
	<cfswitch expression="#arguments.type#">
		<cfcase value="bean">
			<cfset variables.instance.objects[arguments.name].init() />
		</cfcase>
		<cfcase value="model">
			<cfset variables.instance.objects[arguments.name].init() />
		</cfcase>
		<cfcase value="controller">
			<cfset variables.instance.objects[arguments.name].init(variables.fw) />
		</cfcase>
		<cfcase value="service">
			<cfset variables.instance.objects[arguments.name].init(this) />
		</cfcase>
	</cfswitch>
</cffunction>


<cffunction name="functionInjectionHelper" returntype="void" access="private" output="false" hint="Kopiert eine Funktion in ein Objekt">
	<cfargument name="functionName"	type="string" required="true" hint="Der Name der Funktion" />
	<cfargument name="functionData"		type="any" required="true" hint="Die Funktion selbst" />

	<cfif not structKeyExists(variables,arguments.functionName) and not structKeyExists(this,arguments.functionName)>
		<cfset variables[arguments.functionName]	= arguments.functionData />
		<cfset this[arguments.functionName]				= arguments.functionData />
	</cfif>

</cffunction>


<cffunction name="frameworkValidateBean" returntype="any" access="private" output="false" hint="Validiert ein Bean">
	<cfargument name="bean" type="any" required="true" hint="Bean" />
	
	<cfset var local = structNew() />
	<cfset local.keyList = "" />
	
	<cfloop collection="#arguments.bean.getInstance()#" item="local.key">
		<cfif structKeyExists(request.context,local.key) and compare("",request.context[local.key])>
			<cfset local.keyList = listAppend(local.keyList,local.key) />
		</cfif>
	</cfloop>
	
	<cfset populate(arguments.bean,local.keyList,true) />

	<cfset arguments.bean.validateProperties() />
	<cfif arguments.bean.isValid() and structKeyExists(arguments.bean,"validate")>
		<cfset arguments.bean.validate() />
	</cfif>
	
	<cfreturn arguments.bean />
</cffunction>


<cffunction name="modelInit" returntype="any" access="private" output="false" hint="Init Methode die in ein Model eingefuegt wird">
	<cfreturn this />
</cffunction>


<cffunction name="serviceInit" returntype="any" access="private" output="false" hint="Init Methode die in den Service eingefuegt wird">
	<cfargument name="factory" type="any" required="true" hint="Bean Factory Objekt" />
	
	<cfset variables["factory"] = arguments.factory />
	
	<cfreturn this />
</cffunction>


<cffunction name="serviceCreateModel" returntype="any" access="private" output="false" hint="Generischer Getter fuer Models der in den Service eingefuegt wird">
	<cfargument name="modelName" type="string" required="true" hint="Name des Models" />
	
	<cfreturn variables.factory.getBean("#arguments.modelName#Model") />
</cffunction>


<cffunction name="controllerCreateBean" returntype="any" access="private" output="false" hint="Generischer Getter fuer Beans der in den Controller eingefuegt wird">
	<cfargument name="beanName" type="string" required="true" hint="Name des Beans" />
	
	<cfreturn variables.fw.getBeanFactory().getBean("#arguments.beanName#Bean") />
</cffunction>


<cffunction name="beanInit" returntype="any" access="private" output="false" hint="Init Methode die in ein Bean eingefuegt wird">
	<cfset build() />
	<cfreturn this />
</cffunction>


<cffunction name="beanBuild" returntype="any" access="private" output="false" hint="Build Methode die in ein Bean eingefuegt wird">
	<cfscript>
		var local = structNew();
		local.meta = getMetaData(this);
		
		variables.instance	= structNew();
		variables.errors		= structNew();
		variables.valid			= true;

		if( structKeyExists(local.meta,"properties") ){
			local.count = arrayLen(local.meta.properties);
			for( local.i = 1; local.i lte local.count; local.i = local.i + 1){
				variables.instance[local.meta.properties[local.i].name]				= local.meta.properties[local.i];
				variables.instance[local.meta.properties[local.i].name].value	= "";
				if( not structKeyExists(this,"set#local.meta.properties[local.i].name#") ){
					this["set#local.meta.properties[local.i].name#"] = javaCast("null","");
				}
				if( not structKeyExists(this,"get#local.meta.properties[local.i].name#") ){
					this["get#local.meta.properties[local.i].name#"] = javaCast("null","");
				}
			}
		}
	</cfscript>
</cffunction>


<cffunction name="beanGetInstance" returntype="struct" access="private" output="false" hint="Liefert die Instanzdaten eines Beans">

	<cfreturn variables.instance />
</cffunction>


<cffunction name="beanValidateProperties" returntype="void" access="private" output="false" hint="Validate Methode die in ein Bean eingefuegt wird">
	<cfset var local = structNew() />
	
	<cfset variables.valid	= true />
	<cfset variables.errors	= structNew() />
	
	<cfloop collection="#variables.instance#" item="local.key">
		<cfset local.property = variables.instance[local.key]>

		<cfif structKeyExists(local.property,"type") and structKeyExists(local.property,"value")>
			<cfif not compare(local.property.value,"")
					and structKeyExists(local.property,"required")
					and local.property.required
					or compare(local.property.value,"")
					and not isValid(local.property.type,local.property.value)>
				
				<cfset variables.valid												= false />
				<cfset variables.errors[local.property.name]	= local.property />
			</cfif>
		</cfif>
	</cfloop>
</cffunction>


<cffunction name="beanIsValid" returntype="boolean" access="private" output="false" hint="isValid Mehode die in ein Bean eingefuegt wird">
	<cfreturn variables.valid />
</cffunction>


<cffunction name="beanGetErrors" returntype="struct" access="private" output="false" hint="Generischer Getter der Fehler die wuehrend dem Validate Vorgang festgestellt wurden">
	
	<cfreturn variables.errors />
</cffunction>


<cffunction name="beanGet" returntype="any" access="private" output="false" hint="Generischer Getter der in das Bean eingefuegt wird">
	<cfargument name="attribute" type="string" required="true" hint="Attribut des Beans" />
	
	<cfset var local = structNew() />
	<cfset local.value = "" />
	
	<cfif structKeyExists(variables.instance[arguments.attribute],"value") and compare("",variables.instance[arguments.attribute]["value"])>
		<cfset local.value = variables.instance[arguments.attribute]["value"] />
	<cfelseif structKeyExists(variables.instance[arguments.attribute],"default")>
		<cfset local.value = evaluate(variables.instance[arguments.attribute]["default"]) />
	</cfif>
	
	<cfreturn local.value />
</cffunction>


<cffunction name="beanSet" returntype="void" access="private" output="false" hint="Generischer Setter der in das Bean eingefuegt wird (ColdFusion Variante)">
	<cfargument name="attribute"	type="string"	required="true"	hint="Attribut des Beans" />
	<cfargument name="value"			type="any"		required="true"	hint="Wert des Attributs" />
	
	<cfif structKeyExists(variables.instance,arguments.attribute)>
		<cfset variables.instance[arguments.attribute].value = arguments.value />
	</cfif>

</cffunction>


<cffunction name="beanOnMissingMethod" returntype="any" access="private" output="false" hint="Generische Getter und Setter (Railo Variante)">
	<cfargument name="missingMethodName"			type="string"	required="true"	hint="Name der nicht gefundenen Methode" />
	<cfargument name="missingMethodArguments"	type="struct"	required="true"	hint="Argumente die der Methode uebergeben wurden" />
	
	<cfset var local = structNew() />
	
	<cfif len(arguments.missingMethodName) gt 3>
		<cfset local.accessor		= lCase(left(arguments.missingMethodName,3)) />
		<cfset local.attribute	= right(arguments.missingMethodName,len(arguments.missingMethodName) - 3) />
		
		<cfswitch expression="#local.accessor#">
			<cfcase value="get">
				<cfreturn get(local.attribute) />
			</cfcase>
			<cfcase value="set">
				<cfset set(local.attribute,arguments.missingMethodArguments[1]) />
			</cfcase>
		</cfswitch>
	</cfif>
	
</cffunction>

</cfcomponent>