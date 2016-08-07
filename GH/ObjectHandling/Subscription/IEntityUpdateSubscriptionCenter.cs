namespace GH.ObjectHandling.Subscription
{
    using System;

    public interface IEntityUpdateSubscriptionCenter<T1, T2> where T1 : IIdObject<T2>
    {
        void TriggerSubscriptionUpdate(T1 obj);
        void SubscribeForUpdates(Action<T1> action);
        void SubscribeForUpdates(Action<T1> action, Func<T1, bool> filterCondition);
    }
}