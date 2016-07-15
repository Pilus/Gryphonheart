namespace GH.ObjectHandling.Storage
{
    using System;
    using System.Collections.Generic;
    using CsLuaFramework;
    using Lua;
    using Misc;

    public class GuidObjectList<T> : IGuidObjectList<T> where T : class
    {
        private readonly Dictionary<Guid, T> objects;
        private readonly ISerializer serializer;
        private readonly ISavedDataHandler savedDataHandler;
        private bool savedDataLoaded;

        public GuidObjectList(ISerializer serializer, ISavedDataHandler savedDataHandler)
        {
            this.serializer = serializer;
            this.savedDataHandler = savedDataHandler;
            this.objects = new Dictionary<Guid, T>();
        }

        public T Get(Guid guid)
        {
            this.ThrowIfSavedDataIsNotLoaded();
            throw new NotImplementedException();
        }

        public void Set(Guid guid, T obj)
        {
            this.ThrowIfSavedDataIsNotLoaded();
            throw new NotImplementedException();
        }

        public void Remove(Guid guid)
        {
            this.ThrowIfSavedDataIsNotLoaded();
            throw new NotImplementedException();
        }

        public List<Guid> GetGuids()
        {
            this.ThrowIfSavedDataIsNotLoaded();
            throw new NotImplementedException();
        }

        public void LoadFromSaved()
        {
            var data = this.savedDataHandler.GetAll();
            if (data != null)
            {
                Table.Foreach(data, (key, value) => this.LoadObject((Guid) key, (NativeLuaTable) value));
            }
            this.savedDataLoaded = true;
        }

        private void LoadObject(Guid guid, NativeLuaTable info)
        {
            this.objects[guid] = this.serializer.Deserialize<T>(info);
        }

        private void ThrowIfSavedDataIsNotLoaded()
        {
            if (!this.savedDataLoaded)
            {
                throw new Exception("It is not possible to interact with objects before the saved data is loaded.");
            }
        }
    }
}