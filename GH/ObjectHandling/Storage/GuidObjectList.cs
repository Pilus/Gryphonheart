namespace GH.ObjectHandling.Storage
{
    using System;
    using CsLua;
    using CsLua.Collection;
    using Lua;
    using Misc;

    public class GuidObjectList<T> : IGuidObjectList<T>
    {
        private readonly CsLuaDictionary<CsLuaGuid, T> objects;
        private readonly ITableFormatter<T> formatter;
        private readonly ISavedDataHandler savedDataHandler;
        private bool savedDataLoaded;

        public GuidObjectList(ITableFormatter<T> formatter, ISavedDataHandler savedDataHandler)
        {
            this.formatter = formatter;
            this.savedDataHandler = savedDataHandler;
            this.objects = new CsLuaDictionary<CsLuaGuid, T>();
        }

        public T Get(CsLuaGuid guid)
        {
            this.ThrowIfSavedDataIsNotLoaded();
            throw new NotImplementedException();
        }

        public void Set(CsLuaGuid guid, T obj)
        {
            this.ThrowIfSavedDataIsNotLoaded();
            throw new NotImplementedException();
        }

        public void Remove(CsLuaGuid guid)
        {
            this.ThrowIfSavedDataIsNotLoaded();
            throw new NotImplementedException();
        }

        public CsLuaList<CsLuaGuid> GetGuids()
        {
            this.ThrowIfSavedDataIsNotLoaded();
            throw new NotImplementedException();
        }

        public void LoadFromSaved()
        {
            var data = this.savedDataHandler.GetAll();
            if (data != null)
            {
                Table.Foreach(data, (key, value) => this.LoadObject((CsLuaGuid) key, (NativeLuaTable) value));
            }
            this.savedDataLoaded = true;
        }

        private void LoadObject(CsLuaGuid guid, NativeLuaTable info)
        {
            this.objects[guid] = (T) this.formatter.Deserialize(info);
        }

        private void ThrowIfSavedDataIsNotLoaded()
        {
            if (!this.savedDataLoaded)
            {
                throw new CsException("It is not possible to interact with objects before the saved data is loaded.");
            }
        }
    }
}