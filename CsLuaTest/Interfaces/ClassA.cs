using System;

namespace CsLuaTest.Interfaces
{

    public class ClassA<T1, T2> : InterfaceWithGenerics<T2>
    {

        public void Method(T2 arg)
        {
            
        }

        public T3 MethodWithGenericInReturn<T3>(object arg)
        {
            return (T3)arg;
        }

        public void MethodWithGenericInArg<T4>(T4 arg)
        {
        }
    }
}