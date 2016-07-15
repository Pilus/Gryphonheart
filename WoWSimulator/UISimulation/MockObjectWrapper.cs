namespace WoWSimulator.UISimulation
{
    using System;
    using BlizzardApi.Global;
    using CsLuaFramework.Wrapping;
    using Lua;

    public class MockObjectWrapper : IWrapper
    {
        private IApi api;

        public MockObjectWrapper(IApi api)
        {
            this.api = api;
        }

        public NativeLuaTable Unwrap<T>(T obj) where T : class
        {
            throw new NotImplementedException();
        }

        public T Wrap<T>(string globalVarName) where T : class
        {
            return (T)this.api.GetGlobal(globalVarName);
        }

        public T Wrap<T>(string globalVarName, Func<NativeLuaTable, Type> typeTranslator) where T : class
        {
            throw new NotImplementedException();
        }

        public T Wrap<T>(NativeLuaTable luaTable) where T : class
        {
            throw new NotImplementedException();
        }

        public T Wrap<T>(NativeLuaTable luaTable, Func<NativeLuaTable, Type> typeTranslator) where T : class
        {
            throw new NotImplementedException();
        }
    }
}
