namespace CsLuaTest.AmbigousMethods
{
    public class AmbigousMethodsTests : BaseTest
    {
        public AmbigousMethodsTests()
        {
            Name = "AmbigousMethods";
            this.Tests["TestAmbiguousMethodWith1Arg"] = TestAmbiguousMethodWith1Arg;
            this.Tests["TestAmbiguousMethodWith1ArgAndObject"] = TestAmbiguousMethodWith1ArgAndObject;
            this.Tests["TestAmbiguousMethodWith1ArgAndClass"] = TestAmbiguousMethodWith1ArgAndClass;
            this.Tests["TestAmbiguousMethodWithInterface"] = TestAmbiguousMethodWithInterface;
            this.Tests["TestAmbiguousMethodWithInterfaceAndTwoArgs"] = TestAmbiguousMethodWithInterfaceAndTwoArgs;
            this.Tests["TestAmbiguousMethodWithInheritance"] = TestAmbiguousMethodWithInheritance;
            this.Tests["TestNullPickingCorrectMethods"] = TestNullPickingCorrectMethods;
            this.Tests["TestAmbigousMethodsWithEnum"] = TestAmbigousMethodsWithEnum;
            this.Tests["TestAmbigousMethodsWithGenerics"] = TestAmbigousMethodsWithGenerics;
        }

        private static void TestAmbiguousMethodWith1Arg()
        {
            var theClass = new ClassWithAmbigousMethods();

            theClass.OneArg(0);
            Assert("OneArg_Int", Output);

            ResetOutput();
            theClass.OneArg("Test");
            Assert("OneArg_String", Output);
        }

        private static void TestAmbiguousMethodWith1ArgAndObject()
        {
            var theClass = new ClassWithAmbigousMethods();

            theClass.OneArgWithObj(0);
            Assert("OneArgWithObj_Int", Output);

            ResetOutput();
            theClass.OneArgWithObj("Test");
            Assert("OneArgWithObj_Object", Output);
        }

        private static void TestAmbiguousMethodWith1ArgAndClass()
        {
            var theClass = new ClassWithAmbigousMethods();

            theClass.OneArgWithClass(0);
            Assert("OneArgWithClass_Int", Output);

            ResetOutput();
            theClass.OneArgWithClass(new ClassA());
            Assert("OneArgWithClass_ClassA", Output);
        }

        private static void TestAmbiguousMethodWithInterface()
        {
            var theClass = new ClassWithAmbigousMethods();

            theClass.OneArgWithInterface(new ClassB1());
            Assert("OneArgWithInterface_InterfaceB", Output);

            ResetOutput();
            theClass.OneArgWithInterface(new ClassB2());
            Assert("OneArgWithInterface_ClassB2", Output);
        }

        private static void TestAmbiguousMethodWithInterfaceAndTwoArgs()
        {
            var theClass = new ClassWithAmbigousMethods();

            theClass.TwoArgsWithInterface(new ClassB1(), new ClassB2());
            Assert("OneArgWithInterface_InterfaceBClassB2", Output);
        }

        private static void TestAmbiguousMethodWithInheritance()
        {
            var theClass = new ClassC2();

            theClass.Method("x");
            Assert("Method_string", Output);

            ResetOutput();
            theClass.Method(10);
            Assert("Method_int", Output);

            ResetOutput();
            theClass.Method(true);
            Assert("Method_bool", Output);
        }

        private static void TestNullPickingCorrectMethods()
        {
            var theClass = new ClassWithAmbigousMethods();
            
            theClass.NullPicking1(null);
            Assert("NullPicking1_InterfaceB", Output);
        }

        private static void TestAmbigousMethodsWithEnum()
        {
            var theClass = new ClassWithEnumMethod();

            theClass.EnumMethod(EnumA.Value1);
            Assert("MethodEnumA", Output);

            ResetOutput();
            theClass.EnumMethod(EnumB.Something);
            Assert("MethodEnumB", Output);

        }

        private static void TestAmbigousMethodsWithGenerics()
        {
            var theClass = new ClassWithAmbigousMethods();

            theClass.GenericPicking(new ClassWithGenerics<bool>());
            Assert("GenericPicking_bool", Output);

            ResetOutput();
            theClass.GenericPicking(new ClassWithGenerics<int>());
            Assert("GenericPicking_int", Output);
        }

        // TODO scenario where a class overrides a method with one signature, but not one with another. Call both from the base class. 

        // TODO ambigous with CsLuaList


    }
}