namespace GH.ObjectHandling.Subscription
{
    using System;
    using System.Collections.Generic;
    using CsLua.Collection;

    public class SubscriptionCenter<T1, T2>  : ISubscriptionCenter<T1, T2> where T1 : IIdObject<T2>
    {
        private readonly CsLuaDictionary<Func<T1, bool>, Action<T1>> subscribers = new CsLuaDictionary<Func<T1, bool>, Action<T1>>();

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