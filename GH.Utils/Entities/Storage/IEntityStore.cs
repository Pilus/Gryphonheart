//-----------------------–-----------------------–--------------
// <copyright file="IEntityStore.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Utils.Entities.Storage
{
    using System.Collections.Generic;

    /// <summary>
    /// Handling storage of entities, including serialization and update subscription center triggering.
    /// </summary>
    /// <typeparam name="T1">The <see cref="IIdEntityEntity{T}"/> entity type to store.</typeparam>
    /// <typeparam name="T2">The type of the id.</typeparam>
    public interface IEntityStore<T1, T2> where T1 : IIdEntity<T2>
    {
        /// <summary>
        /// Gets the entity with a given id, if available. Otherwise returns null.
        /// </summary>
        /// <param name="id">The id of the entity to get.</param>
        /// <returns>The entity matching the id.</returns>
        T1 Get(T2 id);

        /// <summary>
        /// Gets a list consisting of all ids of the available entities in the dataset.
        /// </summary>
        /// <returns>List of available ids.</returns>
        List<T2> GetIds();

        /// <summary>
        /// Get a list containing all elements in the store.
        /// </summary>
        /// <returns>A <see cref="List{T1}"/> of all elements.</returns>
        List<T1> GetAll();

        /// <summary>
        /// Add a given <see cref="IIdEntityEntity{T}"/> to the store.
        /// </summary>
        /// <param name="entity">The entity to add.</param>
        void Set(T1 entity);

        /// <summary>
        /// Removes an entity with a given id from the store.
        /// </summary>
        /// <param name="id">Id to remove.</param>
        void Remove(T2 id);

        /// <summary>
        /// Let the store load and apply data from the <see cref="ISavedDataHandler"/>.
        /// </summary>
        void LoadFromSaved();
    }
}