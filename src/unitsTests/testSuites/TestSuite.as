package unitsTests.testSuites
{
	import unitsTests.testCases.ResourceBundleTest;
	import unitsTests.testCases.ResourceManagerTest;
	import unitsTests.testCases.XMLResourceParserTest;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class TestSuite
	{
		public var test1:ResourceManagerTest;
		public var test2:XMLResourceParserTest;
		public var test3:ResourceBundleTest;
	}
}