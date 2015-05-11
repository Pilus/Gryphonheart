


namespace CsLua.Collection
{
    using Lua;

    public class TableFormatter : ITableFormatter
    {
        public TableFormatter()
        {

        }
        /// <summary>
        /// CsLua table formatter
        /// </summary>
        /// <param name="compactResult">Wheather or not a not the result should be compacted. Should only be used if there is no circular refferences.</param>
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
