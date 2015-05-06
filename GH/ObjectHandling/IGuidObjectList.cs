namespace GH.ObjectHandling
{
    using System.Collections.Generic;
    using CsLua;

    public interface IGuidObjectList<T>
    {
        T Get(WoWGuid guid);

        void Set(WoWGuid guid, T obj);

        void Remove(WoWGuid guid);

        IEnumerable<WoWGuid> GetGuids();

        void LoadFromSaved();
    }
}