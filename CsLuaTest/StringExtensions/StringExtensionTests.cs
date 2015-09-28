namespace CsLuaTest.StringExtensions
{
    public class StringExtensionTests : BaseTest
    {
        public StringExtensionTests()
        {
            Name = "StringExtension";
            this.Tests["TestLength"] = TestLength;
            this.Tests["TestContains"] = TestContains;
        }

        private static void TestLength()
        {
            var str = "abc";
            Assert(3, str.Length);
        }

        private static void TestContains()
        {
            var str = "abc";
            Assert(true, str.Contains("bc"));
            Assert(false, str.Contains("bcd"));
        }
    }
}