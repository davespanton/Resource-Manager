package com.as3offcuts.parsers
{
	
	/**
	 * The <code>XMLResourceParser</code> class provides an implementation of <code>IParser</code> for 
	 * parsing specific xml value files in to typed objects.
	 * 
	 * <p>An example along with the expected xml format is displayed below.</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * 
	 * 
	 *	var xml:XML = 	<resources locale="en_GB">
	 *				  		<string name="someString">This is a string value</string>
	 * 						<int name="someInt">44</int>
	 * 						<number name="someNumber">3.14</number>
	 *					</resources>
	 * 
	 * var xmlResourceParser:IParser = new XMLResourceParser( );
	 * var data:Object = xmlResourceParser.parse( xml );
	 * 
	 * </listing>
	 */
	public class XMLResourceParser implements IParser
	{
		/**
		 * Takes an xml object or xml representation (e.g. a string representing xml) and 
		 * parses it into an Actionscript object which is returned.
		 * 
		 * <p>This method accepts xml in the format shown in the example above. It is capable 
		 * of converting values to <code>String</code>, <code>int</code> and <code>Number</code>. 
		 * Each of these will be contained in the returned object under the property name given in 
		 * the xml nodes' <code>name</code> attribute.</p>
		 * 
		 * @param	value	A xml obeject or xml representation to parse.
		 * 
		 * @return	Object	The parsed version of the passed value. 
		 */
		public function parse( value:Object ):Object
		{
			// try a coercion of the passed value
			var xml:XML = value as XML;
			// initialise the return object
			var obj:Object = {};
			
			// if coercion failed try making a new xml object from the passed value
			if( !xml )
				xml = new XML(value);
			
			// add a locale
			obj.locale = xml.@locale;
			
			// iterate over named nodes in the xml looking for Strings, ints and Numbers.
			
			for each( var item:XML in xml..string )
			
				obj[item.@name] = item.toString();
			
			for each( item in xml..int )
				obj[item.@name] = int(item.toString());
						
			for each( item in xml..number )
				obj[item.@name] = Number(item.toString());
			
			// return the populated object
			return obj;
		}
	}
}