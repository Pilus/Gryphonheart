namespace CsLuaTest.TypeMethods
{
    public class TypeMethodsTests : BaseTest
    {
        public TypeMethodsTests()
        {
            Name = "TypeMethods";
            this.Tests["TestEquals"] = TestEquals;
            this.Tests["TestToString"] = TestToString;
            this.Tests["TestIntParse"] = TestIntParse;
        }

        private static void TestEquals()
        {
            Assert(true, ("test").Equals("test"));
            Assert(false, ("test").Equals("test2"));

            var i = 43;
            Assert(true, i.Equals(43));

            var c1a = new Class1() {Value = "A"};
            var c1b = new Class1() {Value = "A"};
            var c1c = new Class1() { Value = "C" };
            Assert(true, c1a.Equals(c1b));
            Assert(false, c1a.Equals(c1c));
        }

        private static void TestToString()
        {
            var value = 43.ToString();
            Assert("43", value);

            Assert("43", (43).ToString());
            Assert("43", 43.ToString());

            var x = true;
            Assert("True", x.ToString());

            var c1 = new Class1() {Value = "c1"};
            Assert("c1", c1.ToString());
        }

        private static void TestIntParse()
        {
            Assert(43, int.Parse("43"));
        }
    }
}