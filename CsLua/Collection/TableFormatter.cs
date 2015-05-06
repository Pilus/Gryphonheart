


namespace CsLua.Collection
{
    using Lua;

    public class TableFormatter : ITableFormatter
    {
        public TableFormatter()
        {

        }
        public TableFormatter(bool compactResult)
        {
            
        }
        public NativeLuaTable Serialize(object graph)
        {
            throw new System.NotImplementedException();
        }

        public object Deserialize(NativeLuaTable table)
        {
            throw new System.NotImplementedException();
        }
    }
}
