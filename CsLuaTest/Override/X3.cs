
namespace CsLuaTest.Override
{
    public class X3
    {
        public virtual string Test()
        {
            return "test";
        }

        public virtual void Test2()
        {
            OverrideTest.Output += "X3Test2";
        }

        public virtual void Test3()
        {
            OverrideTest.Output += "X3Test3";
        }

        public virtual void Test4()
        {
            OverrideTest.Output += "X3Test4";
        }

        public virtual void Test5()
        {
            OverrideTest.Output += "X3Test5";
        }

        public virtual void Test6()
        {
            OverrideTest.Output += "X3Test5";
        }
    }
}
