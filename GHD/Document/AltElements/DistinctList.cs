namespace GHD.Document.AltElements
{
    using System.Collections;
    using System.Collections.Generic;
    public class DistinctList<T> : IList<T>
    {
        private readonly List<T> decoratedList = new List<T>();

        public IEnumerator<T> GetEnumerator()
        {
            return this.decoratedList.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return this.decoratedList.GetEnumerator();
        }

        public void Add(T item)
        {
            if (!this.decoratedList.Contains(item))
            {
                this.decoratedList.Add(item);
            }
        }

        public void Clear()
        {
            this.decoratedList.Clear();
        }

        public bool Contains(T item)
        {
            return this.decoratedList.Contains(item);
        }

        public void CopyTo(T[] array, int arrayIndex)
        {
            this.decoratedList.CopyTo(array, arrayIndex);
        }

        public bool Remove(T item)
        {
            return this.decoratedList.Remove(item);
        }

        public int Count
        {
            get
            {
                return this.decoratedList.Count;
            }
        }

        public bool IsReadOnly
        {
            get
            {
                return false;
            }
        }

        public int IndexOf(T item)
        {
            return this.decoratedList.IndexOf(item);
        }

        public void Insert(int index, T item)
        {
            if (!this.decoratedList.Contains(item))
            {
                this.decoratedList.Insert(index, item);
            }
        }

        public void RemoveAt(int index)
        {
            this.decoratedList.RemoveAt(index);
        }

        public T this[int index]
        {
            get
            {
                return this.decoratedList[index];
            }
            set
            {
                this.decoratedList[index] = value;
            }
        }
    }
}