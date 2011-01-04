package unitsTests.testCases
{
	import com.as3offcuts.parsers.XMLResourceParser;
	import com.as3offcuts.resource.ResourceBundle;
	
	import flexunit.framework.Assert;
	
	public class ResourceBundleTest
	{		
		private var xml:XML = 	<resources locale='en_GB'>
									<string name='lib_name'>Resource Manager</string>
									<int name='int_test'>5</int>
									<number name='number_test'>3.14</number>
								</resources>;
		
		[Test]
		public function testGetString():void
		{
			var rb:ResourceBundle = new ResourceBundle("testId", xml, new XMLResourceParser());
			Assert.assertEquals(rb.getString("lib_name"), "Resource Manager");
		}
		
		[Test]
		public function testGetInt():void
		{
			var rb:ResourceBundle = new ResourceBundle("testId", xml, new XMLResourceParser());
			Assert.assertStrictlyEquals(rb.getInt("int_test"), 5);
		}
		
		[Test]
		public function testGetNumber():void
		{
			var rb:ResourceBundle = new ResourceBundle("testId", xml, new XMLResourceParser());
			Assert.assertStrictlyEquals(rb.getNumber("number_test"), 3.14);
		}
		
		[Test]
		public function testId():void
		{
			var rb:ResourceBundle = new ResourceBundle("testId", xml, new XMLResourceParser());
			Assert.assertEquals(rb.id, "testId");
		}
		
		[Test]
		public function testLocale():void
		{
			var rb:ResourceBundle = new ResourceBundle("testId", xml, new XMLResourceParser());
			
			Assert.assertEquals( rb.locale, "en_GB" );
		}
		
		[Test]
		public function testResourceBundle():void
		{
			var rb:ResourceBundle = new ResourceBundle("testId", xml, new XMLResourceParser());
			
			Assert.assertNotNull(rb);
		}
	}
}