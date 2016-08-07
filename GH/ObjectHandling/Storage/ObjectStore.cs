namespace GH.ObjectHandling.Storage
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CsLuaFramework;
    using Lua;
    using Misc;
    using Subscription;

    public class ObjectStore<T1, T2> : IObjectStore<T1, T2>  where T1 : class, IIdObject<T2>
    {
        private readonly ISerializer serializer;
        private readonly List<T1> objects;
        private readonly ISavedDataHandler savedDataHandler;
        private readonly IEntityUpdateSubscriptionCenter<T1, T2> entityUpdateSubscriptionCenter;

        private bool savedDataLoaded;

        public ObjectStore(ISerializer serializer, ISavedDataHandler savedDataHandler, IEntityUpdateSubscriptionCenter<T1, T2> entityUpdateSubscriptionCenter)
        {
            this.serializer = serializer;
            this.objects = new List<T1>();
            this.savedDataHandler = savedDataHandler;
            this.entityUpdateSubscriptionCenter = entityUpdateSubscriptionCenter;
        }

        public ObjectStore(ISerializer serializer, ISavedDataHandler savedDataHandler) : this(serializer, savedDataHandler, null)
        {
        }

        public T1 Get(T2 id)
        {
            this.ThrowIfSavedDataIsNotLoaded();
            return this.objects.FirstOrDefault(o => o.Id.Equals((id)));
        }

        public List<T2> GetIds()
        {
            this.ThrowIfSavedDataIsNotLoaded();
            return this.objects.Select(o => o.Id).ToList();
        }

        public List<T1> GetAll()
        {
            this.ThrowIfSavedDataIsNotLoaded();
            return this.objects;
        }

        public void Set(T1 obj)
        {
            this.ThrowIfSavedDataIsNotLoaded();
            var id = obj.Id;
            var existing = this.Get(id);
            if (existing != null)
            {
                this.objects.Remove(existing);
            }
            this.objects.Add(obj);

            var info = this.serializer.Serialize(obj);
            this.savedDataHandler.SetVar(id, info);

            if (this.entityUpdateSubscriptionCenter != null)
            {
                this.entityUpdateSubscriptionCenter.TriggerSubscriptionUpdate(obj);
            }
        }

        public void Remove(T2 id)
        {
            this.ThrowIfSavedDataIsNotLoaded();
            var existing = this.Get(id);
            if (existing != null)
            {
                this.objects.Remove(existing);
            }
            this.savedDataHandler.SetVar(id, null);
        }

        public void LoadFromSaved()
        {
            var data = this.savedDataHandler.GetAll();
            if (data != null)
            {
                Table.Foreach(data, (key, value) => { this.LoadObject(value as NativeLuaTable); });
            }
            this.savedDataLoaded = true;
        }

        private void LoadObject(NativeLuaTable info)
        {
            this.objects.Add(this.serializer.Deserialize<T1>(info));
        }

        private void ThrowIfSavedDataIsNotLoaded()
        {
            if (!this.savedDataLoaded)
            {
                throw new DataNotLoadedException();
            }
        }
    }
}