namespace CsLuaTest.General
{
    public class GeneralTests : BaseTest
    {
        public GeneralTests()
        {
            this.Tests["TestStaticClassWithMethod"] = TestStaticClassWithMethod;
            this.Tests["NonStaticClassWithStaticMethod"] = NonStaticClassWithStaticMethod;
            this.Tests["TestVariableTypeVsVariableName"] = TestVariableTypeVsVariableName;
            this.Tests["GetConstValueFromBase"] = GetConstValueFromBase;
        }

        private static void TestStaticClassWithMethod()
        {
            StaticClass.Method(1);
            Assert("StaticMethodInt", Output);
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
    }
}