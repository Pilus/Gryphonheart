namespace CsLua.Collection
{
    using System;
    using Lua;
    using System.Runtime.Serialization;
    using System.Reflection;
    using System.Text.RegularExpressions;
    using System.Linq;

    public class TableFormatter<T> : ITableFormatter<T>
    {
        private static Regex backingFieldRegex = new Regex(@"<(\w+)>k__BackingField");
        private const string typeIndex = "__type";
        
        public NativeLuaTable Serialize(T graph)
        {
            return this.SerializeGraph(graph);
        }

        private NativeLuaTable SerializeGraph(object graph)
        {
            var type = graph.GetType();
            var members = FormatterServices.GetSerializableMembers(type);

            object[] objs = FormatterServices.GetObjectData(graph, members);

            NativeLuaTable table = new NativeLuaTable();

            for (var i = 0; i < objs.Length; i++)
            {
                var value = this.SerializeValue(objs[i]);
                if (value != null)
                {
                    table[GetIndexFromInfo(members[i])] = value;
                }
            }

            table[typeIndex] = type.FullName;

            return table;
        }

        private object SerializeValue(object value)
        {
            if (value == null)
            {
                return null;
            }

            if (value is int || value is double || value is float
                || value is bool || value is string || value is NativeLuaTable)
            {
                return value;
            }

            if (value is ISerializable)
            {
                return SerializeISerializeable(value as ISerializable);
            }

            return this.SerializeGraph(value);
        }

        private NativeLuaTable SerializeISerializeable(ISerializable value)
        {
            var type = value.GetType();
            var info = new SerializationInfo(type, new DummyFormatterConverter());
            value.GetObjectData(info, new StreamingContext());

            NativeLuaTable table = new NativeLuaTable();
            foreach (var i in info)
            {
                table[i.Name] = this.SerializeValue(i.Value);
            }

            table[typeIndex] = type.FullName;
            return table;
        }

        private static string GetIndexFromInfo(MemberInfo info)
        {
            var backingFieldMatch = backingFieldRegex.Match(info.Name);
            if (backingFieldMatch.Success)
            {
                return backingFieldMatch.Groups[1].Value;
            }
            return info.Name;
        }

        public T Deserialize(NativeLuaTable table)
        {
            return (T)DeserializeTable(table);
        }

        private static object DeserializeValue(object value)
        {
            if (value is NativeLuaTable)
            {
                return DeserializeTable(value as NativeLuaTable);
            }

            return value;
        }

        private static object DeserializeTable(NativeLuaTable table)
        {
            var typeName = table[typeIndex];
            
            //Assembly.gett
            //FormatterServices.GetTypeFromAssembly()

            var members = FormatterServices.GetSerializableMembers(type);

            var obj = FormatterServices.GetUninitializedObject(type);
            
            var data = new object[]{ };
            
            for (var i=0; i < members.Length; i++)
            {
                var member = members[i];
                var value = table[GetIndexFromInfo(member)];
                data[i] = DeserializeValue(value);
            }

            FormatterServices.PopulateObjectMembers(obj, members, data);

            return obj;
        }

    }

    internal class DummyFormatterConverter : IFormatterConverter
    {
        public object Convert(object value, TypeCode typeCode)
        {
            throw new NotImplementedException();
        }

        public object Convert(object value, Type type)
        {
            throw new NotImplementedException();
        }

        public bool ToBoolean(object value)
        {
            throw new NotImplementedException();
        }

        public byte ToByte(object value)
        {
            throw new NotImplementedException();
        }

        public char ToChar(object value)
        {
            throw new NotImplementedException();
        }

        public DateTime ToDateTime(object value)
        {
            throw new NotImplementedException();
        }

        public decimal ToDecimal(object value)
        {
            throw new NotImplementedException();
        }

        public double ToDouble(object value)
        {
            throw new NotImplementedException();
        }

        public short ToInt16(object value)
        {
            throw new NotImplementedException();
        }

        public int ToInt32(object value)
        {
            throw new NotImplementedException();
        }

        public long ToInt64(object value)
        {
            throw new NotImplementedException();
        }

        public sbyte ToSByte(object value)
        {
            throw new NotImplementedException();
        }

        public float ToSingle(object value)
        {
            throw new NotImplementedException();
        }

        public string ToString(object value)
        {
            throw new NotImplementedException();
        }

        public ushort ToUInt16(object value)
        {
            throw new NotImplementedException();
        }

        public uint ToUInt32(object value)
        {
            throw new NotImplementedException();
        }

        public ulong ToUInt64(object value)
        {
            throw new NotImplementedException();
        }
    }
}
