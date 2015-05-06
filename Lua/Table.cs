

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
            throw new NotImplementedException();
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
            throw new NotImplementedException();
        }

        /// <summary>
        /// Insert value into the table at position pos
        /// </summary>
        /// <param name="t"></param>
        /// <param name="pos">1 based position.</param>
        /// <param name="value"></param>
        public static void insert(NativeLuaTable t, int pos, object value)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Remove and return the last entry in table.
        /// </summary>
        /// <param name="t"></param>
        /// <returns></returns>
        public static object remove(NativeLuaTable t)
        {
            throw new NotImplementedException(); 
        }

        /// <summary>
        /// Remove and return the table element at position pos
        /// </summary>
        /// <param name="t"></param>
        /// <param name="pos">1 based position</param>
        /// <returns></returns>
        public static object remove(NativeLuaTable t, int pos)
        {
            throw new NotImplementedException();
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
