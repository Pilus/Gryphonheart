namespace CsLuaTest.Interfaces
{
    using General;

    class InterfacesTests : BaseTest
    {
        public InterfacesTests()
        {
            this.Tests["InheritiedInterfaceShouldBeloadedInSignature"] = InheritiedInterfaceShouldBeloadedInSignature;
        }

        private static void InheritiedInterfaceShouldBeloadedInSignature()
        {
            var theClass = new InheritingInterfaceImplementation();
            InheritingInterfaceImplementation.AMethodTakingBaseInterface(theClass);
            Assert("OK", Output);
        }
    }
}