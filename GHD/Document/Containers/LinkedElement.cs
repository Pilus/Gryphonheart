

namespace GHD.Document.Containers
{
    public class LinkedElement<T> : ILinkedElement<T>
    {
        public T Prev { get; set; }

        public T Next { get; set; }
    }
}
