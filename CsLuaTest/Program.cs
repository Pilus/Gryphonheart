
namespace CsLuaTest
{
    using TryCatchFinally;
    using AmbigousMethods;
    using CsLua.Collection;
    using DefaultValues;
    using General;
    using Lua;
    using Override;
    using Serialization;

    class Program
    {
        static void Main(string[] args)
        {
            var tests = new CsLuaList<ITestSuite>()
            {
                new TryCatchFinallyTests(),
                new GeneralTests(),
                new AmbigousMethodsTests(),
                new OverrideTest(),
                new SerializationTests(),
                new DefaultValuesTests(),
            };

            tests.Foreach(test => test.PerformTests());
            Core.print("CsLua test completed.");
        }
    }
}
