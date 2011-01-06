package unitsTests.testCases
{
	import com.as3offcuts.parsers.XMLResourceParser;
	
	import flexunit.framework.Assert;
	
	[ExcludeClass]
	public class XMLResourceParserTest
	{		
		[Test]
		public function testParse():void
		{
			var xmlr:XMLResourceParser = new XMLResourceParser();
			var xml:XML = 	<resources locale='en_gb'>
								<string name='lib_name'>Resource Manager</string>
							</resources>
				
			var result:Object = xmlr.parse(xml);
			
			Assert.assertNotNull( result );
			Assert.assertEquals( result["lib_name"], "Resource Manager" );
			Assert.assertEquals( result.locale, "en_gb" );
		}
	}
}