namespace GH.ObjectHandling.Storage
{
    using CsLua.Collection;
    using Misc;

    public class SingleObjectContainer<T> : ISingleObjectContainer<T>
    {
        private readonly ISavedDataHandler savedDataHandler;
        private readonly string key;
        private readonly T defaultValue;
        private readonly ITableFormatter<T> formatter;

        public SingleObjectContainer(ISavedDataHandler savedDataHandler, string key, T defaultValue, ITableFormatter<T> formatter)
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
                return this.defaultValue;
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