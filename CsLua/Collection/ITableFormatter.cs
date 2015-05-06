
namespace CsLua.Collection
{
    using Lua;

    public interface ITableFormatter
    {
        NativeLuaTable Serialize(object graph);

        object Deserialize(NativeLuaTable table);
    }
}
