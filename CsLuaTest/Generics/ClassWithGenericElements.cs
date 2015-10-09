
namespace CsLuaTest.Generics
{
    class ClassWithGenericElements<T>
    {
        public static string StaticString;
        public static T StaticT;

        public T Variable;

        public T Property { get; set; }
    }

    class ClassWithGenericElements
    {
        public static string StaticString;
    }
}
