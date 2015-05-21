namespace GH.ObjectHandling
{
    using CsLua;
    using CsLua.Collection;
    using Lua;
    using Misc;

    public class IdObjectList<T1, T2> : IIdObjectList<T1, T2> where T1 : IIdObject<T2>
    {
        private readonly ITableFormatter<T1> formatter;
        private readonly CsLuaList<T1> objects;
        private readonly ISavedDataHandler savedDataHandler;

        private bool savedDataLoaded;

        public IdObjectList(ITableFormatter<T1> formatter, ISavedDataHandler savedDataHandler)
        {
            this.formatter = formatter;
            this.objects = new CsLuaList<T1>();
            this.savedDataHandler = savedDataHandler;
        }

        public T1 Get(T2 id)
        {
            this.ThrowIfSavedDataIsNotLoaded();
            return this.objects.FirstOrDefault(o => o.Id.Equals((id)));
        }

        public CsLuaList<T2> GetIds()
        {
            this.ThrowIfSavedDataIsNotLoaded();
            return this.objects.Select(o => o.Id);
        }

        public CsLuaList<T1> GetAll()
        {
            this.ThrowIfSavedDataIsNotLoaded();
            return this.objects;
        }

        public void Set(T2 id, T1 obj)
        {
            this.ThrowIfSavedDataIsNotLoaded();
            var existing = this.Get(id);
            if (existing != null)
            {
                this.objects.Remove(existing);
            }

            if (obj == null)
            {
                return;
            }
            this.objects.Add(obj);

            var info = this.formatter.Serialize(obj);
            this.savedDataHandler.SetVar(id, info);
        }

        public void Remove(T2 id)
        {
            this.ThrowIfSavedDataIsNotLoaded();
            var existing = this.Get(id);
            if (existing != null)
            {
                this.objects.Remove(existing);
            }
            this.savedDataHandler.SetVar(id, null);
        }

        public void LoadFromSaved()
        {
            var data = this.savedDataHandler.GetAll();
            if (data != null)
            {
                Table.Foreach(data, (key, value) => { this.LoadObject(value as NativeLuaTable); });
            }
            this.savedDataLoaded = true;
        }

        private void LoadObject(NativeLuaTable info)
        {
            this.objects.Add(this.formatter.Deserialize(info));
        }

        private void ThrowIfSavedDataIsNotLoaded()
        {
            if (!savedDataLoaded)
            {
                throw new CsException("It is not possible to interact with objects before the saved data is loaded.");
            }
        }
    }
}