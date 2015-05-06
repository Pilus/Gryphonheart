
namespace GHD.Document.Containers
{
    public interface ILinkedElement<T>
    {
        T Prev { get; set; }
        T Next { get; set; }
    }
}
