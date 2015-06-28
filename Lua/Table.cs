

namespace Lua
{
    using System;

    public static class Table
    {
        /// <summary>
        /// Return the size of the table when seen as a list
        /// </summary>
        /// <param name="t">A native lua table</param>
        /// <returns></returns>
        public static int getn(NativeLuaTable t)
        {
            return t.__Count();
        }

        public static void Foreach(NativeLuaTable t, Action<object, object> iterator)
        {
            t.__Foreach(iterator);
        }

        /// <summary>
        /// Execute function for each element in table, indices are visited in sequential order. (deprecated, used ipairs instead)
        /// </summary>
        /// <param name="t"></param>
        /// <param name="iterator"></param>
        public static void foreachi(NativeLuaTable t, Action<object, object> iterator)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Sort the elements in the table in-place.
        /// </summary>
        /// <param name="t"></param>
        public static void sort(NativeLuaTable t)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Sort the elements in the table in-place, optionally using a custom comparator.
        /// </summary>
        /// <param name="t"></param>
        /// <param name="comparer"></param>
        public static void sort(NativeLuaTable t, Action<object,object> comparer)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// returns true if value is contained within table.
        /// </summary>
        /// <param name="t"></param>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static bool contains(NativeLuaTable t, object obj)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Insert value into the table at end of table.
        /// </summary>
        /// <param name="t"></param>
        /// <param name="value"></param>
        public static void insert(NativeLuaTable t, object value)
        {
            t[t.__Count() + 1] = value;
        }

        /// <summary>
        /// Insert value into the table at position pos
        /// </summary>
        /// <param name="t"></param>
        /// <param name="pos">1 based position.</param>
        /// <param name="value"></param>
        public static void insert(NativeLuaTable t, int pos, object value)
        {
            for (var i = t.__Count(); i >= pos; i--)
            {
                t[i + 1] = t[i];
            }
            t[pos] = value;
        }

        /// <summary>
        /// Remove and return the last entry in table.
        /// </summary>
        /// <param name="t"></param>
        /// <returns></returns>
        public static object remove(NativeLuaTable t)
        {
            var value = t[t.__Count()];
            t[t.__Count()] = null;
            return value;
        }

        /// <summary>
        /// Remove and return the table element at position pos
        /// </summary>
        /// <param name="t"></param>
        /// <param name="pos">1 based position</param>
        /// <returns></returns>
        public static object remove(NativeLuaTable t, int pos)
        {
            var value = t[pos];
            t[pos] = null;

            for (var i = pos + 1; i <= t.__Count(); i++)
            {
                t[i - 1] = t[i];
                t[i] = null;
            }

            return value;
        }

        /// <summary>
        /// Restore the table to its initial value (like tab = {} without the garbage)
        /// </summary>
        /// <param name="t"></param>
        public static void wipe(NativeLuaTable t)
        {
            throw new NotImplementedException();
        }
    }



}
