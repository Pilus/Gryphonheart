namespace CsLuaTest.General
{
    public class GeneralTests : BaseTest
    {
        public GeneralTests()
        {
            Name = "General";
            this.Tests["NonStaticClassWithStaticMethod"] = NonStaticClassWithStaticMethod;
            this.Tests["TestVariableTypeVsVariableName"] = TestVariableTypeVsVariableName;
            this.Tests["GetConstValueFromBase"] = GetConstValueFromBase;
            this.Tests["ConstructorShouldUseArgumentsOverClassElements"] = ConstructorShouldUseArgumentsOverClassElements;
            this.Tests["MethodShouldUseArgumentsOverClassElements"] = MethodShouldUseArgumentsOverClassElements;
            this.Tests["ClassesShouldBeAbleToUseCustomEqualsImplementation"] = ClassesShouldBeAbleToUseCustomEqualsImplementation;
            this.Tests["MinusEqualsShouldBeHandled"] = MinusEqualsShouldBeHandled;
            this.Tests["CommonStringExtensionsShouldWork"] = CommonStringExtensionsShouldWork;
            this.Tests["HandleAmbigurityBetweenPropertyNameAndType"] = HandleAmbigurityBetweenPropertyNameAndType;
            this.Tests["TestClassWithInitializerAndConstructor"] = TestClassWithInitializerAndConstructor;
        }

        private static void NonStaticClassWithStaticMethod()
        {
            NonStaticClass.StaticMethod(1);
            Assert("StaticMethodInt", Output);
        }

        private static void TestVariableTypeVsVariableName()
        {
            var theClass = new ClassWithTypeAndVariableNaming();
            theClass.Method(() => { });
            Assert("Action", Output);
        }

        private static void GetConstValueFromBase()
        {
            Assert(50, Inheriter.GetConstValue());
        }

        private static void ConstructorShouldUseArgumentsOverClassElements()
        {
            var classA = new ClassAmb("X");
            Assert("X", classA.GetAmbValue());
        }

        private static void MethodShouldUseArgumentsOverClassElements()
        {
            var classA = new ClassAmb("X");
            classA.SetAmbValue("Y");
            Assert("Y", classA.GetAmbValue());
        }

        private static void ClassesShouldBeAbleToUseCustomEqualsImplementation()
        {
            var c1 = new ClassWithEquals() { Value = 1 };
            var c2 = new ClassWithEquals() { Value = 2 };
            var c3 = new ClassWithEquals() { Value = 1 };

            Assert(false, c1.Equals(c2));
            Assert(true, c1.Equals(c3));
        }

        private static void MinusEqualsShouldBeHandled()
        {
            var i = 10;
            i -= 3;

            Assert(7, i);
        }

        private static void CommonStringExtensionsShouldWork()
        {
            var s = "s1";
            Assert(false, string.IsNullOrEmpty(s));

            var s2 = "";
            Assert(true, string.IsNullOrEmpty(s2));

            var i1 = int.Parse("4");
            Assert(4, i1);
        }

        private static void HandleAmbigurityBetweenPropertyNameAndType()
        {
            var c = new ClassWithProperty();

            var s = c.Run("A", "B");
            Assert("AB", s);
        }

        private static void TestClassWithInitializerAndConstructor()
        {
            var c = new ClassInitializerAndCstor("A") { Value = "B" };

            Assert("B", c.Value);
        }
    }
}