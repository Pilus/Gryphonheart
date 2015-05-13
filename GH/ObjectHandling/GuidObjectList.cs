namespace GH.ObjectHandling
{
    using CsLua;
    using CsLua.Collection;
    using Lua;
    using System.Collections.Generic;
    using Misc;
    using System;

    public class GuidObjectList<T> : IGuidObjectList<T>
    {
        private readonly CsLuaDictionary<WoWGuid, T> objects;
        private readonly ITableFormatter<T> formatter;
        private readonly ISavedDataHandler savedDataHandler;
        private bool savedDataLoaded;

        public GuidObjectList(ITableFormatter<T> formatter, ISavedDataHandler savedDataHandler)
        {
            this.formatter = formatter;
            this.savedDataHandler = savedDataHandler;
            this.objects = new CsLuaDictionary<WoWGuid, T>();
        }

        public T Get(WoWGuid guid)
        {
            this.ThrowIfSavedDataIsNotLoaded();
            throw new NotImplementedException();
        }

        public void Set(WoWGuid guid, T obj)
        {
            this.ThrowIfSavedDataIsNotLoaded();
            throw new NotImplementedException();
        }

        public void Remove(WoWGuid guid)
        {
            this.ThrowIfSavedDataIsNotLoaded();
            throw new NotImplementedException();
        }

        public IEnumerable<WoWGuid> GetGuids()
        {
            this.ThrowIfSavedDataIsNotLoaded();
            throw new NotImplementedException();
        }

        public void LoadFromSaved()
        {
            var data = this.savedDataHandler.GetAll();
            if (data != null)
            {
                Table.Foreach(data, (key, value) => this.LoadObject((WoWGuid) key, (NativeLuaTable) value));
            }
            this.savedDataLoaded = true;
        }

        private void LoadObject(WoWGuid guid, NativeLuaTable info)
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