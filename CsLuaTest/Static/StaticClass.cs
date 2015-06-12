namespace CsLuaTest.Static
{
    public static class StaticClass
    {
        public static void Method(int x)
        {
            StaticTests.Output = "StaticMethodInt";
        }

        public static void Method(string x)
        {
            StaticTests.Output = "StaticMethodString";
        }

        public static int Variable = 40;
        public static int GetFromInternal_Variable()
        {
            return Variable;
        }
        public static void SetFromInternal_Variable(int value)
        {
            Variable = value;
        }

        public static int VariableWithDefault;
        public static int GetFromInternal_VariableWithDefault()
        {
            return VariableWithDefault;
        }

        public static int AutoProperty { get; set; }

        private static int backingField;
        public static int PropertyWithGetSet {
            get { return backingField; }
            set { backingField = value*2; } 
        }
    }
}