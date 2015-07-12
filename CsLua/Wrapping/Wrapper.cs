
[assembly: CsLuaAttributes.RequiresCsLuaHeader]

namespace CsLua.Wrapping
{
    using System;
    using Lua;

    public static class Wrapper
    {
        public static T WrapGlobalObject<T>(string name)
        {
            throw new CsException("Wrapping of global objects can only be done in-game.");
        }

        public static T WrapGlobalObject<T>(string name, bool skipValidation)
        {
            throw new CsException("Wrapping of global objects can only be done in-game.");
        }

        public static T WrapGlobalObject<T>(string name, bool skipValidation, Func<NativeLuaTable, string> targetTypeTranslator)
        {
            throw new CsException("Wrapping of global objects can only be done in-game.");
        }

        public static T WrapObject<T>(object obj)
        {
            throw new CsException("Wrapping of objects can only be done in-game.");
        }

        public static T WrapObject<T>(object obj, bool skipValidation)
        {
            throw new CsException("Wrapping of objects can only be done in-game.");
        }

        public static T WrapObject<T>(object obj, bool skipValidation, Func<NativeLuaTable, string> targetTypeTranslator)
        {
            throw new CsException("Wrapping of objects can only be done in-game.");
        }

        public static object TryUnwrapObject<T>(T obj)
        {
            throw new CsException("Unwrapping of objects can only be done in-game.");
        }
    }
}
