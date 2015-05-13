namespace CsLuaTest.AmbigousMethods
{
    public class ClassC2 : ClassC1
    {
        public void Method(string x)
        {
            AmbigousMethodsTests.Output = "Method_string";
        }
    }
}