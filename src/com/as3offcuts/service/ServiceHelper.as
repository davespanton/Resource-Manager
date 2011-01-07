package com.as3offcuts.service
{
	import com.as3offcuts.managers.ResourceManager;
	import com.as3offcuts.parsers.IParser;
	import com.as3offcuts.resource.ResourceBundle;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * Dispatched when a call to execute has finished loading the requested resource and the bundle is available 
	 * in the <code>ResourceManager</code>.
	 */
	[Event(name="complete", type="flash.events.Event")];
	
	/**
	 * Dispathced when an IO error is encountered while trying to load the specified resource.
	 * 
	 * <p>See documentation for <code>URLLoader</code> for more information on this event.</p>
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")];
	
	/**
	 * Dispathced when a security error occurs while trying to load the specified resource.
	 * 
	 * <p>See documentation for <code>URLLoader</code> for more information on this event.</p>
	 */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]; 
	
	/**
	 * The <code>ServiceHelper</code> class is a base class for creating and populating a resource bundle from a 
	 * remote resource. The bundle will be added to the <code>ResourceManager</code> once it has successfully loaded.
	 * 
	 * <p>Access to the bundle will be available once the complete event is dispatched.</p>
	 * 
	 * <p>A <code>ServiceHelper</code> can be used to retrieve and setup multiple different bundles, but is only capable 
	 * of doing so one at a time.</p>
	 * 
	 * @see ResourceManager
	 * @see ResourceBundle
	 * 
	 * @author Dave Spanton.
	 * 
	 */
	public class ServiceHelper extends EventDispatcher
	{
		/**
		 * A <code>URLLoader</code> used to load the requested data resource.
		 */
		protected var urlLoader:URLLoader;
		
		/**
		 * Storage for the id of the most recent request to <code>execute</code>.
		 */
		protected var id:String;
		
		/**
		 * Storage for the <code>IParser</code> instance to be used by an outstanding request to <code>execute</code>.
		 */
		protected var parser:IParser;
		
		// flag indicating if a request is pending.
		private var executing:Boolean = false;
		
		/**
		 * Makes a remote request to the provided url and awaits a return. The passed id will become the id of a 
		 * resource bundle registered with the <code>ResourceManager</code> on completion. 
		 * 
		 * <p>The paseed <code>IParser</code> instance must be capable of parsing the data retrieved.</p>
		 * 
		 * @param	bundleId	The id to register a new bundle with on successfull completion.
		 * @param	parser		An <code>IParser</code> instance capable of parsing the returned data.
		 * @param	url			The url to retrieve data from.
		 */
		public function execute( bundleId:String, parser:IParser, url:String ):void
		{
			if( executing ) {
				throw new Error( "Already executing for id: " + id + ". Can only execute one request as a time." );
				return;
			}
				
			if( !urlLoader )
			{
				urlLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, completeHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			}
			
			id = bundleId;
			this.parser = parser;
			urlLoader.load( new URLRequest(url) );
			executing = true;
		}
		
		/**
		 * Handles successful requests to <code>execute</code> by creating a new resource bundle and registering it 
		 * with the <code>ResourceManager</code>.
		 * 
		 * @param	event	The event object passed to this handler.
		 */
		protected function completeHandler( event:Event ):void
		{
			if( urlLoader && urlLoader.data )
			{
				var bundle:ResourceBundle = getResourceBundle(id, urlLoader.data, parser );
				ResourceManager.getInstance().addBundle(bundle);
			}
			dispatchEvent( new Event( Event.COMPLETE ) );
			cleanup();
		}
		
		/**
		 * Handles errors in requests to <code>execute</code> by forwarding the event object. 
		 * 
		 * @param	event	The event object passed to this handler.
		 */
		protected function errorHandler( event:Event ):void
		{
			dispatchEvent( event.clone() );
			cleanup();
		}
		
		/**
		 * Cleans up properties.
		 */
		protected function cleanup():void
		{
			id = null;
			parser = null;
			urlLoader = null;
			executing = false;
		}
		
		/**
		 * Factory method to create a <code>ResourceBundle</code>. Override this method to use different ResourceBundle 
		 * implementations.
		 * 
		 * @param	id		The id to give the new <code>ResourceBundle</code> instance.
		 * @param	data	The raw data to pass to the new <code>ResourceBundle</code> instance.
		 * @pram	parser	An <code>IParser</code> instance capable of parsing the raw data.
		 */
		protected function getResourceBundle( id:String, data:Object, parser:IParser ):ResourceBundle
		{
			return new ResourceBundle( id, data, parser );
		}
	}
}