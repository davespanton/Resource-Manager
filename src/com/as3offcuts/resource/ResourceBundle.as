package com.as3offcuts.resource
{
	/**
	 * The <code>ResourceBundle</code> class is a collection of data relating to resources that can be used in 
	 * an application. 
	 * 
	 * <p>It can include <code>String</code>, <code>int</code>, <code>Number</code> and <code>Object</code> 
	 * values all of which are stored against <code>String</code> keys.</p>
	 * 
	 * <p>The <code>ResourceBundle</code> required an id, a data object and an <code>IParser</code> that can parse the data. 
	 * It then provides methods to retrieve data by its id key as typed values.</p>
	 * 
	 * <p>The <code>ResourceBundle</code> can also contain a locale value. This is optional, but can be used to seperate 
	 * bundles that for example have the same id value into different locales.</p>
	 * 
	 * <p>Although designed to be used with the <code>ResourceManager</code> class, there is no dependancy upon doing so.</p> 
	 * 
	 * @example
	 * <listing version="3.0">
	 * 
	 * var resourceBundle:ResourceBundler = new ResourceBundle( "someId", someData, new SomeParser() );
	 * ResourceManager.getInstance().addBundle( resourceBundle );
	 * 
	 * </listing> 
	 * 
	 * @see ResourceManager
	 * @see IParser
	 * 
	 * @author Dave Spanton 
	 */
	public class ResourceBundle
	{
		/**
		 * The parsed version of the data object passed to the constructor.
		 */
		protected var data:Object;
		
		// storage for the id passed to the constructor.
		private var _id:String;
		
		/**
		 * An id for this <code>ResourceBundle</code> set during construction.
		 */
		public function get id():String
		{
			return _id;
		}
		
		/**
		 * The locale of this <code>ResourceBundle</code>, as supplied by the passed data during construction.
		 */
		public function get locale():String
		{
			if( data && data.locale )
				return data.locale;
			else
				return "default";
		}
		
		/**
		 * Constructor.
		 * 
		 * @param	id		An id for this instance.
		 * @param	data	An arbitrary data object that can be passed by the <code>IParser</code> parameter.
		 * @param	parser	An <code>IParser</code> object capable of parsing the previous <cod>data</code> parameter.
		 */
		public function ResourceBundle( id:String, data:Object, parser:IParser )
		{
			this.data = parser.parse( data );
			_id = id;
		}
		
		/**
		 * 
		 */
		public function getString( name:String ):String
		{
			if( data.hasOwnProperty( name ) )
				return data[name].toString();
			else 
				return null;
		}
		
		public function getInt( name:String ):int
		{
			if( data.hasOwnProperty( name ) )
				return data[name] as int;
			else
				return NaN;
		}
		
		public function getNumber( name:String ):Number
		{
			if( data.hasOwnProperty( name ) )
				return data[name] as Number;
			else
				return NaN;
		}
		
		public function getObject( name:String ):Object
		{
			if( data.hasOwnProperty( name ) )
				return data[name];
			else
				return null;
		}
	}
}