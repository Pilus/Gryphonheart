namespace CsLua.Collection
{
    using System;
    using System.Collections.Generic;
    using System.Runtime.Serialization;
    using Lua;

    public interface ICsLuaList<T> : IList<T>, ISerializable
    {
        T this[int index] { get; set; }

        int Count { get; }
        bool IsReadOnly { get; }

        void Add(T value);
        CsLuaList<T> AddRange(CsLuaList<T> range);
        bool Any();
        bool Any(Func<T, bool> condition);
        void Clear();
        bool Contains(T item);
        void CopyTo(T[] array, int arrayIndex);
        CsLuaList<T> Distinct();
        T First();
        T First(Func<T, bool> condition);
        T FirstOrDefault();
        T FirstOrDefault(Func<T, bool> condition);
        void Foreach(Action<T> action);
        IEnumerator<T> GetEnumerator();
        void GetObjectData(SerializationInfo info, StreamingContext context);
        int IndexOf(T item);
        void Insert(int index, T item);
        T Last();
        T Last(Func<T, bool> condition);
        T LastOrDefault();
        T LastOrDefault(Func<T, bool> condition);
        double Max(Func<T, double> selector);
        double Min(Func<T, double> selector);
        CsLuaList<T> OrderBy(Func<T, double> selector);
        bool Remove(T item);
        void RemoveAt(int index);
        CsLuaList<TResult> Select<TResult>(Func<T, TResult> selector);
        T Single();
        T Single(Func<T, bool> condition);
        T SingleOrDefault();
        T SingleOrDefault(Func<T, bool> condition);
        CsLuaList<T> Skip(int i);
        double Sum(Func<T, double> selector);
        CsLuaList<T> Take(int i);
        NativeLuaTable ToNativeLuaTable();
        CsLuaList<T> Union(CsLuaList<T> otherList);
        CsLuaList<T> Where(Func<T, bool> condition);
    }
}