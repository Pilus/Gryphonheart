namespace CsLua
{
    using System;
    using CsLua.Wrapping;

    public static class CsLuaStatic
    {
        public static IWrapper Wrapper { get; set; }

        /// <summary>
        /// Creates an instance of the specified type using that type's default constructor.
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        public static object CreateInstance(Type type)
        {
            return Activator.CreateInstance(type);
        }
    }
}
