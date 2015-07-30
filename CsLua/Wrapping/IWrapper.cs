using System;
using Lua;

namespace CsLua.Wrapping
{
    public interface IWrapper
    {
        object TryUnwrapObject<T>(T obj);
        T WrapGlobalObject<T>(string name);
        T WrapGlobalObject<T>(string name, bool skipValidation);
        T WrapGlobalObject<T>(string name, bool skipValidation, Func<NativeLuaTable, string> targetTypeTranslator);
        T WrapObject<T>(object obj);
        T WrapObject<T>(object obj, bool skipValidation);
        T WrapObject<T>(object obj, bool skipValidation, Func<NativeLuaTable, string> targetTypeTranslator);
    }
}