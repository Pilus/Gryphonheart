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

        public static int Variable = 40;

        public static int VariableWithDefault;

        public static int AutoProperty { get; set; }

        private static int backingField;
        public static int PropertyWithGetSet {
            get { return backingField; }
            set { backingField = value*2; } 
        }
    }
}