namespace CsLuaTest.Interfaces
{
    public class InheritingInterfaceImplementation : IInheritingInterface
    {
        public static void AMethodTakingBaseInterface(IBaseInterface arg)
        {
            InterfacesTests.Output = "OK";
        }
         
    }
}