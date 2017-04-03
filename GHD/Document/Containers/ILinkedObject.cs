
namespace GHD.Document.Containers
{
    public interface ILinkedObject<T>
    {
        ILinkedObject<T> Prev { get; set; }
        T Object { get; }
        ILinkedObject<T> Next { get; set; }
    }
}
