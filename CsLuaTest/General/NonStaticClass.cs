namespace CsLuaTest.General
{
    public class NonStaticClass
    {
        public static void StaticMethod(int x)
        {
            GeneralTests.Output = "StaticMethodInt";
        }

        public static void StaticMethod(string x)
        {
            GeneralTests.Output = "StaticMethodString";
        }
    }
}