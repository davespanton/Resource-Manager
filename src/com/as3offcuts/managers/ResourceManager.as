package com.as3offcuts.managers
{
	import com.as3offcuts.resource.ResourceBundle;
	
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	
	/**
	 * The <code>ResourceManager</code> is a Singleton pattern, locale aware manager for resource bundles.
	 * 
	 * <p>Methods are provided to add and remove resource bundles, as well as retrieve values from them in both 
	 * locale specific and locale transperent ways.
	 * 
	 * * @example
	 * <listing version="3.0">
	 * 
	 * var resourceManager:ResourceManager = ResourceManager.getInstance();
	 * resourceManager.addBundle( someBundle );
	 * 
	 * var str:String = resourceManager.getString( "someBundleId", "someString" );
	 * 
	 * </listing> 
	 * 
	 * @see	ResourceBundle
	 * 
	 * @author Dave Spanton.
	 */
	public class ResourceManager
	{
		// Stores the singleton instance.
		private static var instance:ResourceManager;
		// Used as a measure to help prevent direct instantiation.
		private static var valid:Boolean = false;
		
		/**
		 * A locale to use for bundles that do not specify one.
		 */
		protected var defaultLocale:String = "default";
		
		/**
		 * An associative <code>Array</code> used to store id-locale referenced resource bundles.
		 */
		protected var bundles:Array = [];
		
		/**
		 * Singleton method to return the instance of <code>ResourceManager</code>.
		 * 
		 * @return	ResourceManager		The Singleton instance of the resource manager. 
		 */
		public static function getInstance():ResourceManager
		{
			valid = true;
			
			if( !instance )
				instance = new ResourceManager();
			
			return instance;
		}
		
		/**
		 * The locale of the current system.
		 */
		public function get locale():String
		{
			return Capabilities.language;
		}
		
		/**
		 * Constructor.
		 * 
		 * <p>This is a Singleton class. Don't initialise directly, use the static <code>getInstance</code> method.
		 * 
		 * @throws	Error	If instantiated directly.
		 */
		public function ResourceManager()
		{
			if( instance || !valid )
				throw new Error( "ResourceManager is a Singleton. Do not instantiate directly.");
		}
		
		/**
		 * Adds a <code>ResourceBundle</code> to the <code>ResourceManager</code>. The passed bundle will 
		 * be registered using a combination of its <code>id</code> and <code>locale</code> property. 
		 * 
		 * <p>Bundles that have no locale specified are registered under the <code>defaultLocale</code>.</p>
		 * 
		 * @param	bundle	A <code>ResourceBundle</code> instance to add to the <code>ResourceManager</code>.
		 * 
		 */
		public function addBundle( bundle:ResourceBundle ):void
		{
			if( bundle )
				bundles[ bundle.id + bundle.locale ] = bundle;
		}
		
		/**
		 * Removes a bundle from the <code>ResourceManager</code> with the supplied id-locale combination.
		 * 
		 * <p>If both <code>id</code> and <code>locale</code> are provided then the bundle with this combination 
		 * will be removed. If no <code>locale</code> is provided then the bundle with id-default locale is removed.</p>
		 * 
		 * <p>In the case that no bundle can be matched then nothing happens.</p>
		 * 
		 * @param	id		The id of the bundle to remove.
		 * @param	locale	The locale of the bundle to remove. Optional.
		 * 
		 */
		public function removeBundle( id:String, locale:String=null ):void
		{
			var idLoc:String = locale ? id + locale : id + defaultLocale;
			
			if( bundles[idLoc] )
				delete bundles[idLoc];
		}
		
		/**
		 * Returns a <code>ResourceBundle</code> matched against the passed parameters.
		 * 
		 * <p>The bundle searched for will depend upon the locale provided. If one is specified 
		 * then this takes priority. If the specified id-locale combination isn't found then the 
		 * resource bundle with id-current locale will be returned.</p>
		 * 
		 * <p>If neither of the above are found then and no locale is passed then the resource bundle with 
		 * id-default locale is returned. If this isn't found, or a locale was passed, the <code>null</code> is 
		 * returned.<p>
		 * 
		 * <p>Do NOT rely upon this method to chain calls onto its return. Always check the return for a <code>null</code> 
		 * value first.</p>
		 * 
		 * @param	id		The id of the resource bundle to return.
		 * @param	locale	The locale of the resource bundle to return. Optional.
		 * 
		 * @return	ResourceBundle	The returned resource bundle. Can be <code>null</code>.
		 */
		public function getBundle( id:String, locale:String=null ):ResourceBundle
		{
			var idLoc:String = locale ? id + locale : id + this.locale;
			
			if( bundles[idLoc] )
				return bundles[idLoc];
			else if( !locale )
				return bundles[id+defaultLocale];
			else 
				return null;
		}
		
		/**
		 * Returns a <code>String</code> value for the <code>name</code> provided from the resource bundle with the 
		 * passed <code>id</code>. 
		 * 
		 * <p>An optional locale can be passed to specify which locale to retrieve the value from. This follows the 
		 * same order of precedence as the <code>getBundle</code> method.</p>
		 * 
		 * <p>If any combination of the supplied parameters isn't found, then a <code>null</code> value will be returned.</p>
		 * 
		 * @param	id		The id of the resource bundle to retrieve the value from.
		 * @param	name	The name of the resource to retrieve.
		 * @param	locale	The locale for the resource bundle. Optional. 
		 * 
		 * @return	String	The <code>String</code> value requested.
		 * 
		 * @see 	getBundle	  
		 */
		public function getString( id:String, name:String, locale:String=null ):String
		{
			var bundle:ResourceBundle = getBundle(id, locale);
			if( bundle )
				return bundle.getString(name);
			else
				return null;
		}
		
		/**
		 * Returns an <code>int</code> value for the <code>name</code> provided from the resource bundle with the 
		 * passed <code>id</code>. 
		 * 
		 * <p>An optional locale can be passed to specify which locale to retrieve the value from. This follows the 
		 * same order of precedence as the <code>getBundle</code> method.</p>
		 * 
		 * <p>If any combination of the supplied parameters isn't found, then an <code>NaN</code> value will be returned.</p>
		 * 
		 * @param	id		The id of the resource bundle to retrieve the value from.
		 * @param	name	The name of the resource to retrieve.
		 * @param	locale	The locale for the resource bundle. Optional. 
		 * 
		 * @return	String	The <code>String</code> value requested.
		 * 
		 * @see 	getBundle	  
		 */
		public function getInt( id:String, name:String, locale:String=null ):int
		{
			var bundle:ResourceBundle = getBundle(id, locale);
			if( bundle )
				return bundle.getInt(name);
			else
				return NaN;
		}
		
		/**
		 * Returns a <code>Number</code> value for the <code>name</code> provided from the resource bundle with the 
		 * passed <code>id</code>. 
		 * 
		 * <p>An optional locale can be passed to specify which locale to retrieve the value from. This follows the 
		 * same order of precedence as the <code>getBundle</code> method.</p>
		 * 
		 * <p>If any combination of the supplied parameters isn't found, then an <code>NaN</code> value will be returned.</p>
		 * 
		 * @param	id		The id of the resource bundle to retrieve the value from.
		 * @param	name	The name of the resource to retrieve.
		 * @param	locale	The locale for the resource bundle. Optional. 
		 * 
		 * @return	String	The <code>String</code> value requested.
		 * 
		 * @see 	getBundle	  
		 */
		public function getNumber( id:String, name:String, locale:String=null ):Number
		{
			var bundle:ResourceBundle = getBundle(id, locale);
			if( bundle )
				return bundle.getNumber(name);
			else
				return NaN;
		}
		
		/**
		 * Returns an <code>Object</code> value for the <code>name</code> provided from the resource bundle with the 
		 * passed <code>id</code>. 
		 * 
		 * <p>An optional locale can be passed to specify which locale to retrieve the value from. This follows the 
		 * same order of precedence as the <code>getBundle</code> method.</p>
		 * 
		 * <p>If any combination of the supplied parameters isn't found, then a <code>null</code> value will be returned.</p>
		 * 
		 * @param	id		The id of the resource bundle to retrieve the value from.
		 * @param	name	The name of the resource to retrieve.
		 * @param	locale	The locale for the resource bundle. Optional. 
		 * 
		 * @return	String	The <code>String</code> value requested.
		 * 
		 * @see 	getBundle	  
		 */
		public function getObject( id:String, name:String, locale:String=null ):Object
		{
			var bundle:ResourceBundle = getBundle(id, locale);
			if( bundle )
				return bundle.getObject(name);
			else
				return null;
		}
		
	}
}