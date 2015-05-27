namespace CsLuaTest.General
{
    public class InheritingInterfaceImplementation : IInheritingInterface
    {
        public static void AMethodTakingBaseInterface(IBaseInterface arg)
        {
            GeneralTests.Output = "OK";
        }
         
    }
}