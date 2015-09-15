namespace GH.ObjectHandling.Storage
{
    public interface IObjectStoreWithDefaults<T1, T2> : IObjectStore<T1, T2> where T1 : IIdObject<T2>
    {
        void SetDefault(T1 obj);
    }
}