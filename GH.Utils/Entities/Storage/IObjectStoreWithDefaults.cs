//-----------------------–-----------------------–--------------
// <copyright file="IObjectStoreWithDefaults.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Utils.Entities.Storage
{
    /// <summary>
    /// Handling storage of objects, including serialization and update subscription center triggering. 
    /// Also allows for setting of default values, which are calculated on the deserialized data.
    /// </summary>
    /// <typeparam name="T1">The <see cref="IIdObject{T2}"/> object type to store.</typeparam>
    /// <typeparam name="T2">The type of the id.</typeparam>
    public interface IObjectStoreWithDefaults<T1, T2> : IObjectStore<T1, T2> where T1 : IIdObject<T2>
    {
        /// <summary>
        /// Set the default value for an object id.
        /// </summary>
        /// <param name="obj">The object to set.</param>
        void SetDefault(T1 obj);
    }
}