namespace GH.ObjectHandling
{
    public interface IIdObjectListWithDefaults<T1, T2> : IIdObjectList<T1, T2> where T1 : IIdObject<T2>
    {
        void SetDefault(T1 obj);
    }
}