namespace CsLuaTest.Generics
{
    public class GenericsTests : BaseTest
    {
        public GenericsTests()
        {
            this.Tests["TestGenericMethod"] = TestGenericMethod;
            this.Tests["TestGenericConstructor"] = TestGenericConstructor;
            this.Tests["TestGenericVariable"] = TestGenericVariable;
            this.Tests["TestGenericProperty"] = TestGenericProperty;
        }

        private static void TestGenericMethod()
        {
            var theClass = new MethodsWithGeneric<int, string>();

            theClass.GenericMethod(1);
            Assert("GenericMethodT1", Output);

            ResetOutput();
            theClass.GenericMethod("x");
            Assert("GenericMethodT2", Output);
        }

        private static void TestGenericConstructor()
        {
            var theClass = new ClassWithGenericConstructor<string>("ok");
            Assert("GenericConstructorT", Output);
        }

        private static void TestGenericVariable()
        {
            var theClass = new ClassWithGenericElements<int>();

            Assert(0, theClass.Variable);

            theClass.Variable = 43;
            Assert(43, theClass.Variable);
        }

        private static void TestGenericProperty()
        {
            var theClass = new ClassWithGenericElements<int>();

            Assert(0, theClass.Property);

            theClass.Property = 43;
            Assert(43, theClass.Property);
        }
    }
}