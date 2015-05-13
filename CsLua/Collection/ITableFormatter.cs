
namespace CsLua.Collection
{
    using Lua;

    public interface ITableFormatter<T>
    {
        NativeLuaTable Serialize(T graph);

        T Deserialize(NativeLuaTable table);
    }
}
