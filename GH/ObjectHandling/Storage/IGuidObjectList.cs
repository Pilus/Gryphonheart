namespace GH.ObjectHandling.Storage
{
    using CsLua;
    using CsLua.Collection;

    public interface IGuidObjectList<T>
    {
        T Get(CsLuaGuid guid);

        void Set(CsLuaGuid guid, T obj);

        void Remove(CsLuaGuid guid);

        CsLuaList<CsLuaGuid> GetGuids();

        void LoadFromSaved();
    }
}