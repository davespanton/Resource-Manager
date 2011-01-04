package unitsTests.testCases
{
	import com.as3offcuts.managers.ResourceManager;
	import com.as3offcuts.parsers.XMLResourceParser;
	import com.as3offcuts.resource.ResourceBundle;
	
	import flash.system.System;
	
	import flexunit.framework.Assert;
	
	public class ResourceManagerTest
	{	
		private static const TEST_BUNDLE:String = "testBundle";
		
		private var bundleA:ResourceBundle;
		private var bundleB:ResourceBundle;
		
		private var xmlA:XML = 	<resources locale='en_GB'>
									<string name='lib_name'>Resource Manager GB</string>
									<int name='int_test'>5</int>
									<number name='number_test'>3.14</number>
								</resources>;
		
		private var xmlB:XML = 	<resources locale='en'>
									<string name='lib_name'>Resource Manager US</string>
									<int name='int_test'>5</int>
									<number name='number_test'>3.14</number>
								</resources>;
		
		[Before]
		public function setUp():void
		{
			bundleA = new ResourceBundle( TEST_BUNDLE, xmlA, new XMLResourceParser() );
			bundleB = new ResourceBundle( TEST_BUNDLE, xmlB, new XMLResourceParser() );
		}
		
		[After]
		public function tearDown():void
		{
			bundleA = bundleB = null;
			System.disposeXML(xmlA);
			System.disposeXML(xmlB);
		}
				
		
		[Test(expects="Error")]
		public function testResourceManager():void
		{
			new ResourceManager();
		}
		
		[Test]
		public function testGetInstance():void
		{
			var instance:ResourceManager = ResourceManager.getInstance();
			Assert.assertNotNull( instance );
			
			var anotherInstance:ResourceManager = ResourceManager.getInstance();
			Assert.assertStrictlyEquals( instance, anotherInstance );
		}
		
		[Test]
		public function testAddBundle():void
		{
			var rm:ResourceManager = ResourceManager.getInstance();
			rm.addBundle( bundleA );
			
			Assert.assertNotNull( rm.getBundle( TEST_BUNDLE, bundleA.locale ) );
		}
		
		[Test]
		public function testRemoveBundle():void
		{
			var rm:ResourceManager = ResourceManager.getInstance();
			rm.addBundle( bundleA );
			
			rm.removeBundle( TEST_BUNDLE, bundleA.locale );
			
			Assert.assertNull( rm.getBundle( TEST_BUNDLE, bundleA.locale ) );
		}
		
		[Test]
		public function testGetBundle():void
		{
			var rm:ResourceManager = ResourceManager.getInstance();
			rm.addBundle( bundleA );
			rm.addBundle( bundleB );
			
			Assert.assertStrictlyEquals( rm.getBundle( TEST_BUNDLE ), bundleB );
			Assert.assertStrictlyEquals( rm.getBundle( TEST_BUNDLE, bundleA.locale ), bundleA );
		}
		
		[Test]
		public function testGetString():void
		{
			var rm:ResourceManager = ResourceManager.getInstance();
			rm.addBundle( bundleA );
			
			var str:String = rm.getString(TEST_BUNDLE, "lib_name", bundleA.locale);
			
			Assert.assertEquals( str, "Resource Manager GB" );
		}
		
		[Test]
		public function testGetInt():void
		{
			var rm:ResourceManager = ResourceManager.getInstance();
			rm.addBundle( bundleA );
			
			Assert.assertStrictlyEquals( rm.getInt( TEST_BUNDLE, "int_test", "en_GB" ), 5 );
		}
	}
}