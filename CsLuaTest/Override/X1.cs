
namespace CsLuaTest.Override
{
    public class X1 : X2
    {
        public override string Test()
        {
            return base.Test() + "x";
        }

        public void DoTest2()
        {
            base.Test2();
        }

        public override void Test3()
        {
            OverrideTest.Output += "X1Test3";
            base.Test3();
        }

        public override void Test4()
        {
            OverrideTest.Output += "X1Test4";
        }

        public override void Test5()
        {
            OverrideTest.Output += "X1Test5";
        }

        public override void Test6()
        {
            OverrideTest.Output += "X1Test6";
        }

        public void DoTest6()
        {
            base.Test6();
        }
    }
}
