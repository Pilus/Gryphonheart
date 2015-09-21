

namespace CsLua.Collection
{
    using System;
    using System.Collections.Generic;
    using System.Runtime.Serialization;
    using System.Xml;
    using System.Xml.Serialization;
    using Lua;

    public class CsLuaDictionary<TK, TV> : Dictionary<TK, TV>, ISerializable
    {
        #region Constants
        private const string DictionaryNodeName = "Dictionary";
        private const string ItemNodeName = "Item";
        private const string KeyNodeName = "Key";
        private const string ValueNodeName = "Value";
        #endregion

        public CsLuaDictionary(NativeLuaTable nativeTable)
        {

        }

        public CsLuaDictionary()
        {

        }

        public NativeLuaTable ToNativeLuaTable()
        {
            return null;
        }


        protected CsLuaDictionary(SerializationInfo info, StreamingContext context)
        {
            int itemCount = info.GetInt32("ItemCount");
            for (int i = 0; i < itemCount; i++)
            {
                KeyValuePair<TK, TV> kvp = (KeyValuePair<TK, TV>)info.GetValue(String.Format("Item{0}", i), typeof(KeyValuePair<TK, TV>));
                this.Add(kvp.Key, kvp.Value);
            }
        }

        public override void GetObjectData(SerializationInfo info, StreamingContext context)
        {
            if (typeof(TK).Equals(typeof(string)))
            {
                foreach (var pair in this)
                {
                    info.AddValue(pair.Key as string, pair.Value);
                }
            }
            else
            {
                info.AddValue("ItemCount", this.Count);
                int itemIdx = 0;
                foreach (KeyValuePair<TK, TV> kvp in this)
                {
                    info.AddValue(String.Format("Item{0}", itemIdx), kvp, typeof(KeyValuePair<TK, TV>));
                    itemIdx++;
                }
            }
        }
    }
}
