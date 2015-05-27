namespace CsLuaTest.Wrap
{
    using System;
    using CsLua;

    class WrapTests : BaseTest
    {
        public WrapTests()
        {
            this.Tests["WrapSimpleInterface"] = WrapSimpleInterface;
        }

        private static void WrapSimpleInterface()
        {
            var simpleInterface = Wrap.GlobalObject<ISimpleInterface>("x");
        }
    }
}
