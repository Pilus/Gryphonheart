namespace CsLuaTest.Generics
{
    public class ClassWithGenericConstructor<T>
    {
        public ClassWithGenericConstructor(T x)
        {
            GenericsTests.Output = "GenericConstructorT";
        }

        public ClassWithGenericConstructor(int x)
        {
            GenericsTests.Output = "GenericConstructorint";
        }
    }
}