namespace GH.Utils.Entities.Subscription
{
    using System;
    using System.Collections.Generic;

    public class EntityUpdateSubscriptionCenter<T1, T2>  : IEntityUpdateSubscriptionCenter<T1, T2> where T1 : IIdObject<T2>
    {
        private readonly Dictionary<Func<T1, bool>, Action<T1>> subscribers = new Dictionary<Func<T1, bool>, Action<T1>>();

        public void TriggerSubscriptionUpdate(T1 obj)
        {
            foreach (var pair in this.subscribers)
            {
                if (pair.Key(obj))
                {
                    pair.Value(obj);
                }
            }
        }

        public void SubscribeForUpdates(Action<T1> action)
        {
            this.SubscribeForUpdates(action, (_) => true);
        }

        public void SubscribeForUpdates(Action<T1> action, Func<T1, bool> filterCondition)
        {
            this.subscribers.Add(filterCondition, action);
        }
    }
}