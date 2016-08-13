//-----------------------–-----------------------–--------------
// <copyright file="IEntityUpdateSubscriptionCenter.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Utils.Entities.Subscriptions
{
    using System;

    /// <summary>
    /// Handles update notifications for entities.
    /// </summary>
    /// <typeparam name="T1">The <see cref="IIdEntityEntity{T}"/> entity type to store.</typeparam>
    /// <typeparam name="T2">The type of the id.</typeparam>
    public interface IEntityUpdateSubscriptionCenter<T1, T2> where T1 : IIdEntity<T2>
    {
        /// <summary>
        /// Triggers subscription updates for a given entity.
        /// </summary>
        /// <param name="entity">The entity to trigger updates for.</param>
        void TriggerSubscriptionUpdate(T1 entity);

        /// <summary>
        /// Subscribe to updates for any entity.
        /// </summary>
        /// <param name="action">The callback action to call on update.</param>
        void SubscribeForUpdates(Action<T1> action);

        /// <summary>
        /// Subscribe to updates for any entity that fulfills the given filter condition.
        /// </summary>
        /// <param name="action">The callback action to call on update.</param>
        /// <param name="filterCondition">The entity filter condition action.</param>
        void SubscribeForUpdates(Action<T1> action, Func<T1, bool> filterCondition);
    }
}