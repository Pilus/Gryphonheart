namespace GH.ObjectHandling.Storage
{
    using System;
    using System.Collections.Generic;

    public interface IGuidObjectList<T>
    {
        T Get(Guid guid);

        void Set(Guid guid, T obj);

        void Remove(Guid guid);

        List<Guid> GetGuids();

        void LoadFromSaved();
    }
}