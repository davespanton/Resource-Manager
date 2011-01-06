package unitsTests.testCases
{
	import com.as3offcuts.managers.ResourceManager;
	import com.as3offcuts.parsers.XMLResourceParser;
	import com.as3offcuts.service.ServiceHelper;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.sampler.getInvocationCount;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.async.Async;
	
	[ExcludeClass]
	public class ServiceHelperTest
	{
				
		[Test(async)]
		public function testExcute():void
		{
			var asyncHandler:Function = Async.asyncHandler( this, resultHandler, 3000, null, timeoutHandler );
			var serviceHelper:ServiceHelper = new ServiceHelper();
			serviceHelper.addEventListener( Event.COMPLETE, asyncHandler );
			serviceHelper.addEventListener( IOErrorEvent.IO_ERROR, asyncHandler );
			serviceHelper.addEventListener( SecurityErrorEvent.SECURITY_ERROR, asyncHandler );
			serviceHelper.execute( 'testId', new XMLResourceParser(), '../res/test_values.xml' );
			
		}
		
		protected function resultHandler( event:Event, passThroughData:Object ):void
		{
			Assert.assertEquals( event.type, Event.COMPLETE );
			Assert.assertNotNull( ResourceManager.getInstance().getBundle('testId') );
		}
		
		protected function timeoutHandler( passThroughData:Object ):void
		{
			Assert.fail( "Timeout reached before event");
		}
	}
}