namespace CsLuaTest.AmbigousMethods
{
    public class ClassCBase
    {
        public void Method(bool x)
        {
            AmbigousMethodsTests.Output = "Method_bool";
        }
    }
}