namespace CsLuaTest.AmbigousMethods
{
    public class MethodsWithGeneric<T1,T2>
    {
        public void GenericMethod(T1 x)
        {
            AmbigousMethodsTests.Output = "GenericMethodT1";
        }

        public void GenericMethod(T2 x)
        {
            AmbigousMethodsTests.Output = "GenericMethodT2";
        }
    }
}