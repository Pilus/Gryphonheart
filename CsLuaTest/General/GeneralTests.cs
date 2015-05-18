namespace CsLuaTest.General
{
    public class GeneralTests : BaseTest
    {

        public override void PerformTests()
        {
            TestStaticClassWithMethod();
            NonStaticClassWithStaticMethod();
            TestVariableTypeVsVariableName();
            GetConstValueFromBase();
        }

        private static void TestStaticClassWithMethod()
        {
            ResetOutput();
            StaticClass.Method(1);
            Assert("StaticMethodInt", Output);
        }

        private static void NonStaticClassWithStaticMethod()
        {
            ResetOutput();
            NonStaticClass.StaticMethod(1);
            Assert("StaticMethodInt", Output);
        }

        private static void TestVariableTypeVsVariableName()
        {
            ResetOutput();
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