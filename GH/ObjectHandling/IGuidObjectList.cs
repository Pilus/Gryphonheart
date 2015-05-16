namespace GH.ObjectHandling
{
    using CsLua;
    using CsLua.Collection;

    public interface IGuidObjectList<T>
    {
        T Get(WoWGuid guid);

        void Set(WoWGuid guid, T obj);

        void Remove(WoWGuid guid);

        CsLuaList<WoWGuid> GetGuids();

        void LoadFromSaved();
    }
}