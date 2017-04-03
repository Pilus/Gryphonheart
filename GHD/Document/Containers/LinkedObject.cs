

namespace GHD.Document.Containers
{
    public class LinkedObject<T> : ILinkedObject<T>
    {
        public LinkedObject(T o)
        {
            this.Object = o;
        }

        public ILinkedObject<T> Prev { get; set; }
        public T Object { get; private set; }
        public ILinkedObject<T> Next { get; set; }
    }
}
