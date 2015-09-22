

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
        public CsLuaDictionary(NativeLuaTable nativeTable)
        {

        }

        public CsLuaDictionary()
        {

        }

        public CsLuaDictionary(SerializationInfo info, StreamingContext context)
        {
            foreach (var i in info)
            {
                if (i.Value is KeyValuePair<object, object>)
                {
                    var pair = (KeyValuePair<object, object>) i.Value;
                    var key = (TK) pair.Key;
                    var value = (TV) pair.Value;
                    this[key] = value;
                }
                else
                {
                    var key = (TK) (i.Name as object);
                    var value = (TV)i.Value;
                    this[key] = value;
                }
            }
        }

        public NativeLuaTable ToNativeLuaTable()
        {
            return null;
        }

        public override void GetObjectData(SerializationInfo info, StreamingContext context)
        {
            var c = 0;
            foreach (var pair in this)
            {
                var value = new KeyValuePair<object, object>(pair.Key, pair.Value);
                info.AddValue(c + "", value);
                c++;
            }
        }
    }
}
