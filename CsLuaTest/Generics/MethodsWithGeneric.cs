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

        public T3 GenericReturnType<T3>(object value)
        {
            return (T3)value;
        }

        public string GenericAtMethod<T3>(T3 obj)
        {
            return obj.ToString();
        }
    }
}