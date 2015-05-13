namespace CsLuaTest
{
    using System.Runtime.CompilerServices;
    using CsLua;
    using Lua;

    public abstract class BaseTest : ITest
    {
        public static string Output = "";
        public abstract void PerformTests();

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