namespace GH.ObjectHandling.Storage
{
    public interface ISingleObjectContainer<T>
    {
        T Get();

        void Set(T obj);
    }
}