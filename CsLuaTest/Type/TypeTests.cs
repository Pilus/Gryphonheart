namespace CsLuaTest.Type
{
    public class TypeTests : BaseTest
    {
        public TypeTests()
        {
            Name = "Type";
            this.Tests["TestGetTypeOfNumber"] = TestGetTypeOfNumber;
            this.Tests["TestGetTypeOfClass"] = TestGetTypeOfClass;
        }

        private static void TestGetTypeOfNumber()
        {
            var num = 123;
            var type = num.GetType();

            Assert("Int32", type.Name);
            Assert("System", type.Namespace);
            Assert("System.Int32", type.FullName);
        }

        private static void TestGetTypeOfClass()
        {
            var obj = new ClassA();
            var type = obj.GetType();

            Assert("ClassA", type.Name);
            Assert("CsLuaTest.Type", type.Namespace);
        }
    }
}