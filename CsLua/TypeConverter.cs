namespace CsLua
{
    public static class TypeConverter
    {
        public static object EnsureTuple(object obj)
        {
            return obj;
        }

        public static MultipleArguments MultipleArguments(object o1)
        {
            return new MultipleArguments();
        }

        public static MultipleArguments MultipleArguments(object o1, object o2)
        {
            return new MultipleArguments();
        }

        public static MultipleArguments MultipleArguments(object o1, object o2, object o3)
        {
            return new MultipleArguments();
        }
    }
}