namespace GH.ObjectHandling
{
    using System.Collections.Generic;

    public interface IIdObjectList<T1, T2> where T1 : IIdObject<T2>
    {
        T1 Get(T2 id);

        IList<T2> GetIds();

        IEnumerable<T1> GetAll();

        void Set(T2 id, T1 obj);

        void Remove(T2 id);

        void LoadFromSaved();
    }
}