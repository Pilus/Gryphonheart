

namespace CsLuaTest.Override
{
    using Lua;

    public class Base
    {
        public Base()
        {
            OverrideTest.Output += "BaseBlank,";
        }

        public Base(string str)
        {
            OverrideTest.Output += Strings.format("BaseString{0},", str);
        }

        public virtual void M1()
        {
            OverrideTest.Output += "BaseM1,";
        }

        public void M2()
        {
            this.M1();
        }
    }
}
