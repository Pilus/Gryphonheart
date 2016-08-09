
namespace GH.Utils
{
    using Lua;

    public interface ISavedDataHandler
    {
        NativeLuaTable GetVar(object index);

        void SetVar(object index, NativeLuaTable obj);

        NativeLuaTable GetAll();
    }
}