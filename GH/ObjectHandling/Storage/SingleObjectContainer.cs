namespace GH.ObjectHandling.Storage
{
    using CsLuaFramework;
    using Misc;

    public class SingleObjectContainer<T> : ISingleObjectContainer<T> where T : class
    {
        private readonly ISavedDataHandler savedDataHandler;
        private readonly string key;
        private readonly T defaultValue;
        private readonly ISerializer serializer;

        public SingleObjectContainer(ISavedDataHandler savedDataHandler, string key, T defaultValue, ISerializer serializer)
        {
            this.savedDataHandler = savedDataHandler;
            this.key = key;
            this.defaultValue = defaultValue;
            this.serializer = serializer;
        }

        public T Get()
        {
            var value = this.savedDataHandler.GetVar(this.key);
            if (value == null)
            {
                return this.defaultValue;
            }
            return this.serializer.Deserialize<T>(value);
        }

        public void Set(T obj)
        {
            var value = this.serializer.Serialize(obj);
            this.savedDataHandler.SetVar(this.key, value);
        }
    }
}