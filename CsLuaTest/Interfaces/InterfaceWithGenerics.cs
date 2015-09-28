namespace CsLuaTest.Interfaces
{
    public interface InterfaceWithGenerics<T>
    {
        void Method(T arg);

        void MethodWithGenericInArg<T3>(T3 arg);

        T2 MethodWithGenericInReturn<T2>(object arg);
    }
}