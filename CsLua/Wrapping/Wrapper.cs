
[assembly: CsLua.Attributes.RequiresCsLuaHeader]

namespace CsLua.Wrapping
{

    public static class Wrapper
    {
        public static T WrapGlobalObject<T>(string name)
        {
            throw new CsException("Wrapping of global objects can only be done in-game.");
        }

        public static T WrapObject<T>(object obj)
        {
            throw new CsException("Wrapping of objects can only be done in-game.");
        }

        public static object TryUnwrapObject<T>(T obj)
        {
            throw new CsException("Unwrapping of objects can only be done in-game.");
        }
    }
}
