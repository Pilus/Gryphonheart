namespace CsLuaTest.Type
{
    public class TypeTests : BaseTest
    {
        public TypeTests()
        {
            Name = "Type";
            this.Tests["TestGetTypeOfNumber"] = TestGetTypeOfNumber;
            this.Tests["TestGetTypeOfClass"] = TestGetTypeOfClass;
            this.Tests["TestIsType"] = TestIsType;
            this.Tests["TestIsInstanceOf"] = TestIsInstanceOf;
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

        private static void TestIsType()
        {
            Assert(true, new ClassA() is ClassA);
            Assert(true, new ClassB() is ClassA);
            Assert(false, new ClassA() is ClassB);
            Assert(true, new ClassB() is ClassB);
        }

        private static void TestIsInstanceOf()
        {
            var obj = new ClassA();
            
            Assert(true, obj is ClassA);
            Assert(true, obj is InterfaceA);

            var typeClass = typeof(ClassA);
            Assert(true, typeClass.IsInstanceOfType(obj));
            

            var typeInterface = typeof(InterfaceA);
            Assert(true, typeInterface.IsInstanceOfType(obj));
        }
    }
}