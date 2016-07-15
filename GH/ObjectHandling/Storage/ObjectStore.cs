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
        private readonly ISubscriptionCenter<T1, T2> subscriptionCenter;

        private bool savedDataLoaded;

        public ObjectStore(ISerializer serializer, ISavedDataHandler savedDataHandler, ISubscriptionCenter<T1, T2> subscriptionCenter)
        {
            this.serializer = serializer;
            this.objects = new List<T1>();
            this.savedDataHandler = savedDataHandler;
            this.subscriptionCenter = subscriptionCenter;
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

        public void Set(T2 id, T1 obj)
        {
            this.ThrowIfSavedDataIsNotLoaded();
            var existing = this.Get(id);
            if (existing != null)
            {
                this.objects.Remove(existing);
            }

            if (obj == null)
            {
                return;
            }
            this.objects.Add(obj);

            var info = this.serializer.Serialize(obj);
            this.savedDataHandler.SetVar(id, info);

            if (this.subscriptionCenter != null)
            {
                this.subscriptionCenter.TriggerSubscriptionUpdate(obj);
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
                throw new Exception("It is not possible to interact with objects before the saved data is loaded.");
            }
        }
    }
}