package com.as3offcuts.parsers
{
	import com.as3offcuts.resource.IParser;

	public class XMLResourceParser implements IParser
	{
		public function parse( value:Object ):Object
		{
			var xml:XML = value as XML;
			var obj:Object = {};
			
			if( !xml )
				xml = new XML(value);
			
			obj.locale = xml.@locale;
			
			for each( var item:XML in xml..string )
			
				obj[item.@name] = item.toString();
			
			for each( item in xml..int )
				obj[item.@name] = int(item.toString());
			
			
			for each( item in xml..number )
				obj[item.@name] = Number(item.toString());
			
			return obj;
		}
	}
}