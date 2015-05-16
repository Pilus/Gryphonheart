
namespace CsLuaTest
{
    using AmbigousMethods;
    using CsLua.Collection;
    using General;
    using Lua;
    using Override;
    using Serialization;

    class Program
    {
        static void Main(string[] args)
        {
            var tests = new CsLuaList<ITest>()
            {
                new GeneralTests(),
                new AmbigousMethodsTests(),
                new OverrideTest(),
                new SerializationTests(),
            };

            tests.Foreach(test => test.PerformTests());
            Core.print("CsLua test completed.");
        }
    }
}
