namespace CsLua.Collection
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;
    using System.Runtime.Serialization;
    using System.Text.RegularExpressions;
    using Lua;
    
    public class TableFormatter<T> : ITableFormatter<T>
    {
        private static Regex backingFieldRegex = new Regex(@"<(\w+)>k__BackingField");
        private static Regex nonStringIndexRegex = new Regex(@"<(\w+);(.+)>");
        private const string typeIndex = "__type";
        private const string arraySizeIndex = "__size";
        
        public NativeLuaTable Serialize(T graph)
        {
            return (NativeLuaTable)SerializeValue(graph);
        }

        private static NativeLuaTable SerializeGraph(object graph)
        {
            var type = graph.GetType();
            var members = FormatterServices.GetSerializableMembers(type);

            object[] objs = FormatterServices.GetObjectData(graph, members);

            NativeLuaTable table = new NativeLuaTable();

            for (var i = 0; i < objs.Length; i++)
            {
                var value = SerializeValue(objs[i]);
                if (value != null)
                {
                    table[GetIndexFromInfo(members[i])] = value;
                }
            }

            table[typeIndex] = type.FullName;

            return table;
        }

        private static object SerializeValue(object value)
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

            if (value.GetType().IsArray)
            {
                return SerializeArray(value as Array);
            }

            return SerializeGraph(value);
        }

        private static NativeLuaTable SerializeArray(Array value)
        {
            var type = value.GetType();
            NativeLuaTable table = new NativeLuaTable();

            for (var i = 0; i < value.Length; i++)
            {
                table[i] = value.GetValue(i);
            }

            table[typeIndex] = type.FullName;
            table[arraySizeIndex] = value.Length;
            return table;
        }

        private static NativeLuaTable SerializeISerializeable(ISerializable value)
        {
            var type = value.GetType();
            var info = new SerializationInfo(type, new DummyFormatterConverter());
            value.GetObjectData(info, new StreamingContext());

            NativeLuaTable table = new NativeLuaTable();
            foreach (var i in info)
            {
                if (i.Value is KeyValuePair<object, object>)
                {
                    var pair = (KeyValuePair<object, object>) i.Value;
                    table[pair.Key] = SerializeValue(pair.Value);
                }
                else
                {
                    table[i.Name] = SerializeValue(i.Value);
                }
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
            return (T)DeserializeValue(table);
        }

        private static object DeserializeValue(object value)
        {
            if (value is NativeLuaTable)
            {
                return DeserializeTable(value as NativeLuaTable);
            }

            return value;
        }

        private static Type LoadType(string typeName)
        {
            var type = Type.GetType(typeName);
            if (type != null)
            {
                return type;
            }

            var assembly = Assembly.Load(typeName.Split('.')[0]);

            return assembly.GetType(typeName);
        }

        private static object DeserializeTable(NativeLuaTable table)
        {
            var typeName = table[typeIndex] as string;
            if (typeName.EndsWith("[]"))
            {
                return DeserializeArray(table);
            }

            var type = LoadType(typeName);
            var obj = FormatterServices.GetUninitializedObject(type);
            
            if (obj is ISerializable)
            {
                return DeserializeISerializeable(table, type);
            }

            var members = FormatterServices.GetSerializableMembers(type);
            var data =
                members.Select(member => table[GetIndexFromInfo(member)])
                    .Select(DeserializeValue)
                    .ToArray();

            FormatterServices.PopulateObjectMembers(obj, members, data);

            return obj;
        }

        private static object DeserializeISerializeable(NativeLuaTable table, Type type)
        {
            var constructor = type.GetConstructor(new Type[] {typeof(SerializationInfo), typeof(StreamingContext) });
            var info = new SerializationInfo(type, new DummyFormatterConverter());

            Table.Foreach(table, (key, value) =>
            {
                var deserializedValue = DeserializeValue(value);
                if (key is string)
                {
                    info.AddValue((string)key, deserializedValue, deserializedValue.GetType());
                }
                else
                {
                    var pair = new KeyValuePair<object, object>(key, deserializedValue);
                    info.AddValue("" + key, pair, pair.GetType());
                }
            });

            return constructor.Invoke(new object[] { info, new StreamingContext() });
        }

        private static object DeserializeArray(NativeLuaTable table)
        {
            var typeName = (table[typeIndex] as string).Replace("[]", "");
            var size = (int)table[arraySizeIndex];

            var arrayType = LoadType(typeName);

            var array = Array.CreateInstance(arrayType, size);

            for (var i = 0; i < size; i++)
            {
                array.SetValue(table[i], i);
            }

            return array;
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
            return value;
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
