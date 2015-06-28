
namespace Lua
{
    using System;
    using System.Collections.Generic;

    public class NativeLuaTable
    {
        private readonly Dictionary<object, object> innerDictionary = new Dictionary<object, object>();

        public int __Count()
        {
            var i = 1;
            while (this.innerDictionary.ContainsKey(i) && this.innerDictionary[i] != null)
            {
                i++;
            }
            return i - 1;
        }

        public void __Foreach(Action<object, object> action)
        {
            foreach (var o in this.innerDictionary)
            {
                action(o.Key, o.Value);
            }
        }

        public object this[object key]
        {
            get { return this.innerDictionary.ContainsKey(key) ? this.innerDictionary[key] : null; }
            set { this.innerDictionary[key] = value; }
        }
    }
}
