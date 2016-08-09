//-----------------------–-----------------------–--------------
// <copyright file="ObjectStore.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Utils.Entities.Storage
{
    using System.Collections.Generic;
    using System.Linq;

    using CsLuaFramework;

    using GH.Utils.Entities.Subscription;

    using Lua;

    /// <summary>
    /// Handling storage of objects, including serialization and update subscription center triggering.
    /// </summary>
    /// <typeparam name="T1">The <see cref="IIdObject{T2}"/> object type to store.</typeparam>
    /// <typeparam name="T2">The type of the id.</typeparam>
    public class ObjectStore<T1, T2> : IObjectStore<T1, T2> where T1 : class, IIdObject<T2>
    {
        /// <summary>
        /// The serializer.
        /// </summary>
        private readonly ISerializer serializer;

        /// <summary>
        /// The list of objects in the store.
        /// </summary>
        private readonly List<T1> objects;

        /// <summary>
        /// Handler for the saved data.
        /// </summary>
        private readonly ISavedDataHandler savedDataHandler;

        /// <summary>
        /// Subscription center to send entity update notifications to.
        /// </summary>
        private readonly IEntityUpdateSubscriptionCenter<T1, T2> entityUpdateSubscriptionCenter;

        /// <summary>
        /// A flag indicating whether the saved data have been loaded yet.
        /// </summary>
        private bool savedDataLoaded;

        /// <summary>
        /// Initializes a new instance of the <see cref="ObjectStore{T1,T2}"/> class.
        /// </summary>
        /// <param name="serializer">The serializer for handling serialization to <see cref="NativeLuaTable"/>.</param>
        /// <param name="savedDataHandler">Handler for the saving the data to global lua table.</param>
        /// <param name="entityUpdateSubscriptionCenter">Subscription center for updates to the data entity.</param>
        public ObjectStore(ISerializer serializer, ISavedDataHandler savedDataHandler, IEntityUpdateSubscriptionCenter<T1, T2> entityUpdateSubscriptionCenter)
        {
            this.serializer = serializer;
            this.objects = new List<T1>();
            this.savedDataHandler = savedDataHandler;
            this.entityUpdateSubscriptionCenter = entityUpdateSubscriptionCenter;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ObjectStore{T1,T2}"/> class.
        /// </summary>
        /// <param name="serializer">The serializer for handling serialization to <see cref="NativeLuaTable"/>.</param>
        /// <param name="savedDataHandler">Handler for the saving the data to global lua table.</param>
        public ObjectStore(ISerializer serializer, ISavedDataHandler savedDataHandler) : this(serializer, savedDataHandler, null)
        {
        }

        /// <summary>
        /// Gets the entity with a given id, if available. Otherwise returns null.
        /// </summary>
        /// <param name="id">The id of the entity to get.</param>
        /// <returns>The entity matching the id.</returns>
        public T1 Get(T2 id)
        {
            this.ThrowIfSavedDataIsNotLoaded();
            return this.objects.FirstOrDefault(o => o.Id.Equals(id));
        }

        /// <summary>
        /// Gets a list consisting of all ids of the available entities in the dataset.
        /// </summary>
        /// <returns>List of available ids.</returns>
        public List<T2> GetIds()
        {
            this.ThrowIfSavedDataIsNotLoaded();
            return this.objects.Select(o => o.Id).ToList();
        }

        /// <summary>
        /// Get a list containing all elements in the store.
        /// </summary>
        /// <returns>A <see cref="List{T1}"/> of all elements.</returns>
        public List<T1> GetAll()
        {
            this.ThrowIfSavedDataIsNotLoaded();
            return this.objects;
        }

        /// <summary>
        /// Add a given <see cref="IIdObject{T2}"/> to the store.
        /// </summary>
        /// <param name="obj">The object to add.</param>
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

        /// <summary>
        /// Removes an object with a given id from the store.
        /// </summary>
        /// <param name="id">Id to remove.</param>
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

        /// <summary>
        /// Let the store load and apply data from the <see cref="ISavedDataHandler"/>.
        /// </summary>
        public void LoadFromSaved()
        {
            var data = this.savedDataHandler.GetAll();
            if (data != null)
            {
                Table.Foreach(data, (key, value) => { this.LoadObject(value as NativeLuaTable); });
            }

            this.savedDataLoaded = true;
        }

        /// <summary>
        /// Deserialize an object from data table and add it to the objects list.
        /// </summary>
        /// <param name="info">The data table.</param>
        private void LoadObject(NativeLuaTable info)
        {
            this.objects.Add(this.serializer.Deserialize<T1>(info));
        }

        /// <summary>
        /// Throw a <see cref="DataNotLoadedException"/> if the savedDataLoaded variable is false.
        /// </summary>
        private void ThrowIfSavedDataIsNotLoaded()
        {
            if (!this.savedDataLoaded)
            {
                throw new DataNotLoadedException();
            }
        }
    }
}