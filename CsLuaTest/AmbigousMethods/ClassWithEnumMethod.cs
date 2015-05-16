namespace CsLuaTest.AmbigousMethods
{
    public class ClassWithEnumMethod
    {
        public void EnumMethod(EnumA val)
        {
            AmbigousMethodsTests.Output = "MethodEnumA";
        }

        public void EnumMethod(EnumB val)
        {
            AmbigousMethodsTests.Output = "MethodEnumB";
        }
    }
}