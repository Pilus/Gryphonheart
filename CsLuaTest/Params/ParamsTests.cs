namespace CsLuaTest.Params
{
    public class ParamsTests : BaseTest
    {
        public ParamsTests()
        {
            this.Name = "Params";
            this.Tests["BasicParamsScenario"] = BasicParamsScenario;
            this.Tests["ParamsWithAmbigiousMethod"] = ParamsWithAmbigiousMethod;
            this.Tests["TestActionWithParams"] = TestActionWithParams;
            this.Tests["AdvancedParamsScenario"] = AdvancedParamsScenario;
        }

        private static void BasicParamsScenario()
        {
            var c = new ClassWithParams();

            var i1 = c.Method1(true);
            Assert(0, i1);

            var i2 = c.Method1(true, "abc");
            Assert(1, i2);

            var i3 = c.Method1(true, "abc", "def", "ghi");
            Assert(3, i3);
        }

        private static void AdvancedParamsScenario()
        {
            var c = new ClassWithParams();

            var i1 = c.Method2();
            Assert(0, i1);

            var i2 = c.Method2("abc");
            Assert(1, i2);

            var i3 = c.Method2("abc", "def", "ghi");
            Assert(3, i3);
        }

        private static void ParamsWithAmbigiousMethod()
        {
            var c = new ClassWithParams();
            Assert("Method3_string2", c.Method3("abc", "def"));

            Assert("Method3_int3", c.Method3(1, 2, 7));

            Assert("Method3_object4", c.Method3(1, 2, 7, "abc"));
        }

        private static void TestActionWithParams()
        {
            var c = new ClassWithParams();

            c.MethodExpectingAction(ActionWithParams);

            
        }

        private static void ActionWithParams(params object[] args)
        {

        }
    }
}