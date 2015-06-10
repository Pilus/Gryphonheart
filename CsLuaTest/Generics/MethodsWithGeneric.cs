namespace CsLuaTest.Generics
{
    public class MethodsWithGeneric<T1,T2>
    {
        public void GenericMethod(T1 x)
        {
            BaseTest.Output = "GenericMethodT1";
        }

        public void GenericMethod(T2 x)
        {
            BaseTest.Output = "GenericMethodT2";
        }
    }
}