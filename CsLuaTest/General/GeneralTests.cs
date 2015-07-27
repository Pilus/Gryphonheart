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
    }
}