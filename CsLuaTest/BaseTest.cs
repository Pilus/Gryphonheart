namespace CsLuaTest
{
    using System;
    using CsLua.Collection;
    using CsLua;
    using Lua;

    public abstract class BaseTest : ITestSuite
    {
        public static string Output = "";
        public const bool ContinueOnError = false;

        public CsLuaDictionary<string, Action> Tests
        {
            get; protected set;
        }

        public BaseTest()
        {
            this.Tests = new CsLuaDictionary<string, Action>();
        }

        public void PerformTests()
        {
            foreach (var test in this.Tests)
            {
                if (ContinueOnError)
                { 
                    try
                    {
                        ResetOutput();
                        test.Value();
                    }
                    catch (CsException ex)
                    {
                        Core.print("Test failed", test.Key, ex.Message);
                    }
                }
                else
                {
                    ResetOutput();
                    test.Value();
                }
            }
        }

        protected static void ResetOutput()
        {
            Output = "";
        }

        protected static void Assert(object expectedValueObj, object actualValueObj)
        {
            var expectedValue = Strings.tostring(expectedValueObj);
            var actualValue = Strings.tostring(actualValueObj);

            if (expectedValue != actualValue)
            {
                throw new CsException(Strings.format("Incorrect value. Expected: '{0}' got: '{1}'.", expectedValue, actualValue));
            }
        }
    }
}