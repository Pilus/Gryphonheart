namespace GH.ObjectHandling
{
    using CsLua.Collection;
    using Lua;
    using Misc;

    public class SingleObjectContainer<T> : ISingleObjectContainer<T>
    {
        private readonly ISavedDataHandler savedDataHandler;
        private readonly string key;
        private readonly T defaultValue;
        private readonly ITableFormatter formatter;

        public SingleObjectContainer(ISavedDataHandler savedDataHandler, string key, T defaultValue, ITableFormatter formatter)
        {
            this.savedDataHandler = savedDataHandler;
            this.key = key;
            this.defaultValue = defaultValue;
            this.formatter = formatter;
        }

        public T Get()
        {
            var value = this.savedDataHandler.GetVar(this.key);
            if (value == null)
            {
                return defaultValue;
            }
            return (T) this.formatter.Deserialize(value);
        }

        public void Set(T obj)
        {
            var value = this.formatter.Serialize(obj);
            this.savedDataHandler.SetVar(this.key, value);
        }
    }
}