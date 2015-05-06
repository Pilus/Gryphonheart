namespace GH.ObjectHandling
{
    public interface ISingleObjectContainer<T>
    {
        T Get();

        void Set(T obj);
    }
}