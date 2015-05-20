namespace CsLuaTest.DefaultValues
{
    using System;

    public class DefaultValuesClass
    {
        public static int StaticInt;
        public static string StaticString;
        public static Action StaticAction;
        public static Func<int> StaticFunc;
        public static ReferencedClass StaticClass;
        public static AnEnum StaticEnum;
        public static bool StaticBool;

        public int Int;
        public string String;
        public Action AnAction;
        public Func<int> AFunc;
        public ReferencedClass AClass;
        public AnEnum Enum;
        public bool Bool;
    }
}