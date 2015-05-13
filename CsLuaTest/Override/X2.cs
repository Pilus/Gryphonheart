

namespace CsLuaTest.Override
{
    public class X2 : X3
    {
        public override void Test2()
        {
            OverrideTest.Output += "X2Test2";
        }

        public override void Test3()
        {
            OverrideTest.Output += "X2Test3";
            base.Test3();
        }

        public void DoTest4()
        {
            this.Test4();
        }

        public override void Test5()
        {
            OverrideTest.Output += "X2Test5";
        }

        public void DoTest5()
        {
            this.Test5();
        }

        public override void Test6()
        {
            OverrideTest.Output += "X2Test6";
        }
    }
}
