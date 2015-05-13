

namespace CsLuaTest.Override
{
    using CsLua;
    using Lua;

    public class OverrideTest : BaseTest
    {
        public override void PerformTests()
        {
            TestConstructors();
            TestMethods();
            TestMultiLayerMethods();
            TestMultiLayerJumps();
        }

        public static void TestConstructors()
        {
            Output = "";
            new Inheriter();
            Assert("BaseStringtest,InheriterBlank,", Output);

            Output = "";
            new Inheriter(1);
            Assert("BaseBlank,InheriterInt1,", Output);
        }

        public static void TestMethods()
        {
            var obj = new Inheriter();

            Output = "";
            obj.M1();
            Assert("InheriterM1,BaseM1,", Output);

            Output = "";
            obj.M2();
            Assert("InheriterM1,BaseM1,", Output);
        }

        public static void TestMultiLayerMethods()
        {
            var obj = new Level4();

            Output = "";
            obj.M();
            Assert("Level4M,", Output);

            Output = "";
            obj.Level4Self();
            Assert("Level4M,", Output);

            Output = "";
            obj.Level4Base();
            Assert("Level3M,", Output);

            Output = "";
            obj.Level3Self();
            Assert("Level4M,", Output);

            Output = "";
            obj.Level3Base();
            Assert("Level2M,", Output);

            Output = "";
            obj.Level2Self();
            Assert("Level4M,", Output);

            Output = "";
            obj.Level2Base();
            Assert("Level1M,", Output);

            Output = "";
            obj.Level1Self();
            Assert("Level4M,", Output);
        }

        public static void TestMultiLayerJumps()
        {
            var x1 = new X1();

            var res = x1.Test();
            Assert("testx", res);

            Output = "";
            x1.DoTest2();
            Assert("X2Test2", Output);

            Output = "";
            x1.Test3();
            Assert("X1Test3X2Test3X3Test3", Output);

            Output = "";
            x1.DoTest4();
            Assert("X1Test4", Output);

            Output = "";
            x1.DoTest5();
            Assert("X1Test5", Output);

            Output = "";
            x1.DoTest6();
            Assert("X2Test6", Output);

        }
    }
}
