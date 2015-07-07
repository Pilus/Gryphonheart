


namespace CsLua.Collection
{
    using System.IO;
    using System.Xml.Serialization;
    using Lua;

    public class TableFormatter<T> : ITableFormatter<T>
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
        public NativeLuaTable Serialize(T graph)
        {
            var serializer = new XmlSerializer(typeof(T));
            var stream = new MemoryStream();
            serializer.Serialize(stream, graph);

            stream.Position = 0;
            TextReader tr = new StreamReader(stream);
            var str = tr.ReadToEnd();
            
            var table = new NativeLuaTable();
            table["obj"] = str;
            return table;
        }

        public T Deserialize(NativeLuaTable table)
        {
            var stream = new MemoryStream();
            var writer = new StreamWriter(stream);
            writer.WriteLine((string) table["obj"]);
            writer.Flush();

            stream.Position = 0;
            var serializer = new XmlSerializer(typeof(T));
            return (T)serializer.Deserialize(stream);
        }
    }
}
