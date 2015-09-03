
namespace CsLuaTest.General
{
    public class ClassWithProperty
    {
        public string ACommonName { get; set; }

        public string Run(string a, string b)
        {
            ACommonName = a;
            var obj = new ACommonName(b);

            return ACommonName + obj.Value;
        }
    }
}
