

namespace CsLua.Collection
{
    using System.Collections.Generic;
    using Lua;

    public class CsLuaDictionary<TK, TV> : Dictionary<TK, TV>
    {
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
    }
}
