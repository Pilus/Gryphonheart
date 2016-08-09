//-----------------------–-----------------------–--------------
// <copyright file="ObjectStoreWithDefaults.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Utils.Entities.Storage
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    using CsLuaFramework;

    using GH.Utils.Entities.Subscription;

    using Lua;

    /// <summary>
    /// Handling storage of objects, including serialization. 
    /// Also allows for setting of default values, which are calculated on the deserialized data.
    /// When saving it only saves the information that is not present in the default object.
    /// When loading it supplements the loaded information with the default.
    /// </summary>
    /// <typeparam name="T1">The <see cref="IIdObject{T2}"/> object type to store.</typeparam>
    /// <typeparam name="T2">The type of the id.</typeparam>
    public class ObjectStoreWithDefaults<T1, T2> : IObjectStoreWithDefaults<T1, T2> where T1 : class, IIdObject<T2>
    {
        /// <summary>
        /// The list of default objects.
        /// </summary>
        private readonly List<T1> defaultObjects;

        /// <summary>
        /// The object serializer.
        /// </summary>
        private readonly ISerializer serializer;

        /// <summary>
        /// List of objects in the store.
        /// </summary>
        private readonly List<T1> objects;

        /// <summary>
        /// Saved data handler.
        /// </summary>
        private readonly ISavedDataHandler savedDataHandler;

        /// <summary>
        /// Subscription center to send entity update notifications to.
        /// </summary>
        private readonly IEntityUpdateSubscriptionCenter<T1, T2> entityUpdateSubscriptionCenter;

        /// <summary>
        /// A flag indicating whether the saved data have been loaded from the saved data handler or not.
        /// </summary>
        private bool savedDataLoaded;

        /// <summary>
        /// Initializes a new instance of the <see cref="ObjectStoreWithDefaults{T1,T2}"/> class.
        /// </summary>
        /// <param name="serializer">The serializer for handling serialization to <see cref="NativeLuaTable"/>.</param>
        /// <param name="savedDataHandler">Handler for the saving the data to global lua table.</param>
        /// <param name="entityUpdateSubscriptionCenter">Subscription center for updates to the data entity.</param>
        public ObjectStoreWithDefaults(ISerializer serializer, ISavedDataHandler savedDataHandler, IEntityUpdateSubscriptionCenter<T1, T2> entityUpdateSubscriptionCenter)
        {
            this.savedDataHandler = savedDataHandler;
            this.defaultObjects = new List<T1>();
            this.objects = new List<T1>();
            this.serializer = serializer;
            this.entityUpdateSubscriptionCenter = entityUpdateSubscriptionCenter;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ObjectStoreWithDefaults{T1,T2}"/> class.
        /// </summary>
        /// <param name="serializer">The serializer for handling serialization to <see cref="NativeLuaTable"/>.</param>
        /// <param name="savedDataHandler">Handler for the saving the data to global lua table.</param>
        public ObjectStoreWithDefaults(ISerializer serializer, ISavedDataHandler savedDataHandler) : this(serializer, savedDataHandler, null)
        {
        }

        /// <summary>
        /// Set the default value for an object id.
        /// </summary>
        /// <param name="obj">The object to set.</param>
        public void SetDefault(T1 obj)
        {
            if (obj == null)
            {
                throw new ArgumentNullException(nameof(obj));
            }

            if (this.savedDataLoaded)
            {
                throw new DefaultObjectCanNotBeSetAfterLoadException(obj.Id);
            }

            if (this.defaultObjects.Any(o => o.Id.Equals(obj.Id)))
            {
                throw new DefaultObjectAlreadySetException(obj.Id);
            }

            this.defaultObjects.Add(obj);
        }

        /// <summary>
        /// Gets the entity with a given id, if available. Otherwise returns null.
        /// </summary>
        /// <param name="id">The id of the entity to get.</param>
        /// <returns>The entity matching the id.</returns>
        public T1 Get(T2 id)
        {
            this.ThrowIfSavedDataIsNotLoaded();
            var obj = this.objects.FirstOrDefault(o => o.Id.Equals(id));
            if (obj != null)
            {
                return obj;
            }

            var defaultObj = this.defaultObjects.FirstOrDefault(o => o.Id.Equals(id));
            if (defaultObj != null)
            {
                return defaultObj;
            }

            throw new NoDefaultValueFoundException(id);
        }

        /// <summary>
        /// Gets a list consisting of all ids of the available entities in the dataset.
        /// </summary>
        /// <returns>List of available ids.</returns>
        public List<T2> GetIds()
        {
            this.ThrowIfSavedDataIsNotLoaded();
            return this.objects.Select(o => o.Id).Union(this.defaultObjects.Select(o => o.Id)).Distinct().ToList();
        }

        /// <summary>
        /// Get a list containing all elements in the store.
        /// </summary>
        /// <returns>A <see cref="List{T1}"/> of all elements.</returns>
        public List<T1> GetAll()
        {
            this.ThrowIfSavedDataIsNotLoaded();
            return this.objects.Union(this.defaultObjects).ToList();
        }

        /// <summary>
        /// Add a given <see cref="IIdObject{T2}"/> to the store.
        /// </summary>
        /// <param name="obj">The object to add.</param>
        public void Set(T1 obj)
        {
            if (obj == null)
            {
                throw new ArgumentNullException(nameof(obj));
            }

            this.ThrowIfSavedDataIsNotLoaded();
            var id = obj.Id;
            var existing = this.objects.FirstOrDefault(o => o.Id.Equals(id));
            if (existing != null)
            {
                this.objects.Remove(existing);
            }

            this.objects.Add(obj);
            var info = this.serializer.Serialize(obj);

            var defaultObj = this.defaultObjects.FirstOrDefault(o => o.Id.Equals(id));
            if (defaultObj != null)
            {
                info = DifferenceUA(info, this.serializer.Serialize(defaultObj));
            }

            this.savedDataHandler.SetVar(obj.Id as string, info);
            this.entityUpdateSubscriptionCenter.TriggerSubscriptionUpdate(obj);
        }

        /// <summary>
        /// Removes an object with a given id from the store.
        /// </summary>
        /// <param name="id">Id to remove.</param>
        public void Remove(T2 id)
        {
            this.ThrowIfSavedDataIsNotLoaded();
            T1 existing = this.objects.FirstOrDefault(o => o.Id.Equals(id));
            if (existing != null)
            {
                this.objects.Remove(existing);
            }
        }

        /// <summary>
        /// Let the store load and apply data from the <see cref="ISavedDataHandler"/>.
        /// </summary>
        public void LoadFromSaved()
        {
            var data = this.savedDataHandler.GetAll();
            if (data != null)
            {
                Table.Foreach(data, (key, value) => this.LoadObject(key, (NativeLuaTable)value));
            }

            this.savedDataLoaded = true;
        }

        /// <summary>
        /// Merge u into a.
        /// </summary>
        /// <param name="u">The u set.</param>
        /// <param name="a">The a set.</param>
        /// <returns>U merged into a.</returns>
        private static NativeLuaTable MergeUA(NativeLuaTable u, NativeLuaTable a)
        {
            Table.Foreach(
                u, 
                (key, value) =>
                {
                    if (Core.type(value) == "table" && Core.type(a[key]) == "table")
                    {
                        a[key] = MergeUA(value as NativeLuaTable, a[key] as NativeLuaTable);
                    }
                    else
                    {
                        a[key] = value;
                    }
                });
            return a;
        }

        /// <summary>
        /// Returns the set of all elements in u which is not in a.
        /// </summary>
        /// <param name="u">The u set.</param>
        /// <param name="a">The a set.</param>
        /// <returns>All elements in u that are not in a.</returns>
        private static NativeLuaTable DifferenceUA(NativeLuaTable u, NativeLuaTable a)
        {
            var res = new NativeLuaTable();
            var changed = false;

            Table.Foreach(
                u, 
                (key, value) =>
                {
                    if (a[key] == null)
                    {
                        res[key] = value;
                        changed = true;
                    }
                    else if (Core.type(value) == "table" && Core.type(a[key]) == "table")
                    {
                        var r = DifferenceUA(value as NativeLuaTable, a[key] as NativeLuaTable);
                        if (r == null)
                        {
                            return;
                        }

                        res[key] = r;
                        changed = true;
                    }
                    else
                    {
                        if (value.Equals(a[key]))
                        {
                            return;
                        }

                        res[key] = value;
                        changed = true;
                    }
                });

            return changed ? res : null;
        }

        /// <summary>
        /// Throws a <see cref="DataNotLoadedException"/> if the savedDataLoaded flag have not been set to true.
        /// </summary>
        private void ThrowIfSavedDataIsNotLoaded()
        {
            if (!this.savedDataLoaded)
            {
                throw new DataNotLoadedException();
            }
        }

        /// <summary>
        /// Loads an object with a provided id and a provided set of default serialized info.
        /// </summary>
        /// <param name="id">The id of the object to load.</param>
        /// <param name="defaultInfo">The serialized default info to compare with.</param>
        private void LoadObject(object id, NativeLuaTable defaultInfo)
        {
            T1 defaultObj = this.defaultObjects.FirstOrDefault(o => o.Id.Equals(id));
            if (defaultObj != null)
            {
                defaultInfo = MergeUA(defaultInfo, this.serializer.Serialize(defaultObj));
            }

            this.objects.Add(this.serializer.Deserialize<T1>(defaultInfo));
        }
    }
}