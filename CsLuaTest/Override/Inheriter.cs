

namespace CsLuaTest.Override
{
    using Lua;

    public class Inheriter : Base
    {
        public Inheriter() : base("test")
        {
            OverrideTest.Output += "InheriterBlank,";
        }

        public Inheriter(int x)
        {
            OverrideTest.Output += Strings.format("InheriterInt{0},", x);
        }

        public override void M1()
        {
            OverrideTest.Output += "InheriterM1,";
            base.M1();
        }
    }
}
