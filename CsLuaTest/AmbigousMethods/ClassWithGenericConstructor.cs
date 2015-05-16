namespace CsLuaTest.AmbigousMethods
{
    public class ClassWithGenericConstructor<T>
    {
        public ClassWithGenericConstructor(T x)
        {
            AmbigousMethodsTests.Output = "GenericConstructorT";
        }

        public ClassWithGenericConstructor(int x)
        {
            AmbigousMethodsTests.Output = "GenericConstructorint";
        }
    }
}