namespace WoWSimulator.UISimulation
{
    using System;
    using CsLua.Wrapping;
    using Lua;
    using BlizzardApi.Global;

    public class MockObjectWrapper : IWrapper
    {
        private IApi api;

        public MockObjectWrapper(IApi api)
        {
            this.api = api;
        }

        public object TryUnwrapObject<T>(T obj)
        {
            throw new NotImplementedException();
        }

        public T WrapGlobalObject<T>(string name)
        {
            return this.WrapGlobalObject<T>(name, false, null);
        }

        public T WrapGlobalObject<T>(string name, bool skipValidation)
        {
            return this.WrapGlobalObject<T>(name, skipValidation, null);
        }

        public T WrapGlobalObject<T>(string name, bool skipValidation, Func<NativeLuaTable, string> targetTypeTranslator)
        {
            var obj = this.api.GetGlobal(name);
            return this.WrapObject<T>(obj, skipValidation, null);
        }

        public T WrapObject<T>(object obj)
        {
            return this.WrapObject<T>(obj, false, null);
        }

        public T WrapObject<T>(object obj, bool skipValidation)
        {
            return this.WrapObject<T>(obj, skipValidation, null);
        }

        public T WrapObject<T>(object obj, bool skipValidation, Func<NativeLuaTable, string> targetTypeTranslator)
        {
            return (T) obj;
        }
    }
}
