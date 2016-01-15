
namespace CsLuaTest
{
    using System.Collections.Generic;
    using System.Linq;

    using AmbigousMethods;
    using Arrays;
    using CsLua.Collection;
    using CsLuaAttributes;
    using Generics;
    using DefaultValues;
    using General;
    using Interfaces;
    using Lua;
    using Override;
    using Params;
    using Serialization;
    using TryCatchFinally;
    using Wrap;
    using Static;
    using StringExtensions;
    using Type;
    using TypeMethods;

    [CsLuaAddOn("CsLuaTest", "CsLua Test", 60200, Author = "Pilus", Notes = "Unit tests for the CsLua framework.")]
    public class CsLuaTest : ICsLuaAddOn
    {
        public void Execute()
        {
            var tests = new List<ITestSuite>()
            {
                new GeneralTests(),
                new TypeTests(),
                new TryCatchFinallyTests(),
                new AmbigousMethodsTests(),
                new OverrideTest(),
                new SerializationTests(),
                new DefaultValuesTests(),
                new InterfacesTests(),
                new WrapTests(),
                new GenericsTests(),
                new StaticTests(),
                new TypeMethodsTests(),
                new ParamsTests(),
                new ArraysTests(),
                new StringExtensionTests(),
            };

            tests.ForEach(test => test.PerformTests(new IndentedLineWriter()));
            Core.print("CsLua test completed.");
            Core.print(BaseTest.TestCount, "tests run.", BaseTest.FailCount, "failed.", BaseTest.TestCount - BaseTest.FailCount, "succeded.");
        }
    }
}
