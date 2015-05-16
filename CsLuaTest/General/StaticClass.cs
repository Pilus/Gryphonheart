namespace CsLuaTest.General
{
    public static class StaticClass
    {
        public static void Method(int x)
        {
            GeneralTests.Output = "StaticMethodInt";
        }

        public static void Method(string x)
        {
            GeneralTests.Output = "StaticMethodString";
        }
    }
}