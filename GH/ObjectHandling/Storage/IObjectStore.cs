namespace GH.ObjectHandling.Storage
{
    using CsLua.Collection;

    public interface IObjectStore<T1, T2> where T1 : IIdObject<T2>
    {
        T1 Get(T2 id);

        CsLuaList<T2> GetIds();

        CsLuaList<T1> GetAll();

        void Set(T2 id, T1 obj);

        void Remove(T2 id);

        void LoadFromSaved();
    }
}