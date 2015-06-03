



namespace Lua
{
    using System;

    /// <summary>
    /// Mocks the behavior of all core lua functions.
    /// </summary>
    public static class Core
    {
        public static string type(object obj)
        {
            if (obj == null) return "nil";
            var type = obj.GetType().Name;

            switch (type)
            {
                case "int":
                case "long":
                case "float":
                    return "number";
                case "string":
                case "boolean":
                    return type;
                case "Func":
                    return "function";
                default:
                    return "table";
            }
        }

        public static long time()
        {
            DateTime epoch = new DateTime(1970, 1, 1);
            TimeSpan timeSpan = (DateTime.Now - epoch);
            return timeSpan.Ticks / 10000000;
        }

        public static void print(string msg)
        {
            Console.WriteLine(msg);
        }

        public static void print(string s1, string s2)
        {
            Console.WriteLine(string.Concat(s1, s2));
        }

        public static void print(string s1, string s2, string s3)
        {
            Console.WriteLine(string.Concat(s1, s2, s3));
        }

        public static void print(object msg)
        {
            Console.WriteLine(msg);
        }

        public static void print(object s1, object s2)
        {
            Console.WriteLine(string.Concat(s1, s2));
        }

        public static void print(object s1, object s2, object s3)
        {
            Console.WriteLine(string.Concat(s1, s2, s3));
        }

        public static void print(object s1, object s2, object s3, object s4)
        {
            Console.WriteLine(string.Concat(s1, s2, s3, s4));
        }
    }
}
