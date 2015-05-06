
namespace GH.Misc
{
    using System.Collections.Generic;
    using Lua;

    public interface ISavedDataHandler
    {
        NativeLuaTable GetVar(object index);

        void SetVar(object index, NativeLuaTable obj);

        NativeLuaTable GetAll();
    }
}