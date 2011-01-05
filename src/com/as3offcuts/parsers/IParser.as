package com.as3offcuts.parsers
{
	/**
	 * The <code>IParser</code> interface provides a simple interface that allows various sources of 
	 * data to be parsed into Actionscript objects. 
	 */
	public interface IParser
	{
		function parse( value:Object ):Object;
	}
}