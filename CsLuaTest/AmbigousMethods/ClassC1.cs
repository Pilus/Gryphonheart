namespace CsLuaTest.AmbigousMethods
{
    public class ClassC1 : ClassCBase
    {
        public void Method(int x)
        {
            AmbigousMethodsTests.Output = "Method_int";
        }
    }
}