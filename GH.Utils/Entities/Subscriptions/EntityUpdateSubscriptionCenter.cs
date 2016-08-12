//-----------------------–-----------------------–--------------
// <copyright file="EntityUpdateSubscriptionCenter.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------

namespace GH.Utils.Entities.Subscriptions
{
    using System;
    using System.Collections.Generic;

    /// <summary>
    /// Handles update notifications for entities.
    /// </summary>
    /// <typeparam name="T1">The <see cref="IIdObject{T2}"/> object type to store.</typeparam>
    /// <typeparam name="T2">The type of the id.</typeparam>
    public class EntityUpdateSubscriptionCenter<T1, T2> : IEntityUpdateSubscriptionCenter<T1, T2> where T1 : IIdObject<T2>
    {
        /// <summary>
        /// List of subscribers for with actions and condition methods.
        /// </summary>
        private readonly Dictionary<Func<T1, bool>, Action<T1>> subscribers = new Dictionary<Func<T1, bool>, Action<T1>>();

        /// <summary>
        /// Triggers subscription updates for a given entity.
        /// </summary>
        /// <param name="entity">The entity to trigger updates for.</param>
        public void TriggerSubscriptionUpdate(T1 entity)
        {
            foreach (var pair in this.subscribers)
            {
                if (pair.Key(entity))
                {
                    pair.Value(entity);
                }
            }
        }

        /// <summary>
        /// Subscribe to updates for any entity.
        /// </summary>
        /// <param name="action">The callback action to call on update.</param>
        public void SubscribeForUpdates(Action<T1> action)
        {
            this.SubscribeForUpdates(action, (_) => true);
        }

        /// <summary>
        /// Subscribe to updates for any entity that fulfills the given filter condition.
        /// </summary>
        /// <param name="action">The callback action to call on update.</param>
        /// <param name="filterCondition">The entity filter condition action.</param>
        public void SubscribeForUpdates(Action<T1> action, Func<T1, bool> filterCondition)
        {
            this.subscribers.Add(filterCondition, action);
        }
    }
}