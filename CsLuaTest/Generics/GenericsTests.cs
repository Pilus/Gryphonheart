namespace CsLuaTest.Generics
{
    public class GenericsTests : BaseTest
    {
        public GenericsTests()
        {
            Name = "Generics";
            this.Tests["TestGenericMethod"] = TestGenericMethod;
            this.Tests["TestGenericConstructor"] = TestGenericConstructor;
            this.Tests["TestGenericVariable"] = TestGenericVariable;
            this.Tests["TestGenericProperty"] = TestGenericProperty;
            this.Tests["TestGenericReturnArg"] = TestGenericReturnArg;
            this.Tests["TestGenericReturnSpecificForMethod"] = TestGenericReturnSpecificForMethod;
            this.Tests["TestGenericStatic"] = TestGenericStatic;
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

        private static void TestGenericReturnArg()
        {
            var theClass = new MethodsWithGeneric<int, int>();

            var value1 = theClass.GenericReturnType<bool>(true);
            Assert(true, value1);

            var value2 = theClass.GenericReturnType<string>("test");
            Assert("test", value2);
        }

        private static void TestGenericReturnSpecificForMethod()
        {
            var theClass = new MethodsWithGeneric<int, int>();

            var value1 = theClass.GenericAtMethod<string>("test");
            Assert("test", value1);

            var value2 = theClass.GenericAtMethod("test2");
            Assert("test2", value2);

            var value3 = theClass.GenericAtMethod<bool>(true);
            Assert("True", value3);

            var value4 = theClass.GenericAtMethod<ClassA>(new ClassA("test4"));
            Assert("test4", value4);

            var obj = new ClassA("test5");
            var value5 = theClass.GenericAtMethod(obj);
            Assert("test5", value5);
        }

        private static void TestGenericStatic()
        {
            ClassWithGenericElements<int>.StaticT = 2;
            ClassWithGenericElements<int>.StaticString = "X";

            ClassWithGenericElements<bool>.StaticT = true;
            ClassWithGenericElements<bool>.StaticString = "Y";

            ClassWithGenericElements.StaticString = "Z";

            Assert(2, ClassWithGenericElements<int>.StaticT);
            Assert("X", ClassWithGenericElements<int>.StaticString);
            Assert(true, ClassWithGenericElements<bool>.StaticT);
            Assert("Y", ClassWithGenericElements<bool>.StaticString);

            Assert("Z", ClassWithGenericElements.StaticString);
        }
    }
}