//-----------------------–-----------------------–--------------
// <copyright file="IEntityStoreWithDefaults.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Utils.Entities.Storage
{
    /// <summary>
    /// Handling storage of entities, including serialization and update subscription center triggering. 
    /// Also allows for setting of default values, which are calculated on the deserialized data.
    /// </summary>
    /// <typeparam name="T1">The <see cref="IIdEntityEntity{T}"/> entity type to store.</typeparam>
    /// <typeparam name="T2">The type of the id.</typeparam>
    public interface IEntityStoreWithDefaults<T1, T2> : IEntityStore<T1, T2> where T1 : IIdEntity<T2>
    {
        /// <summary>
        /// Set the default value for an entity id.
        /// </summary>
        /// <param name="entity">The entity to set.</param>
        void SetDefault(T1 entity);
    }
}