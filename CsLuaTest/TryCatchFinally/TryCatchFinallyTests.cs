
namespace CsLuaTest.TryCatchFinally
{
    using CsLua;

    public class TryCatchFinallyTests : BaseTest
    {
        public TryCatchFinallyTests() 
        {
            this.Tests["TestSimpleThrow"] = TestSimpleThrow;
            this.Tests["TestFinally"] = TestFinally;
            this.Tests["TestFinallyWithCatch"] = TestFinallyWithCatch;
            this.Tests["TestFinallyWithCatchAndExceptionType"] = TestFinallyWithCatchAndExceptionType;
            this.Tests["TestFinallyWithCatchAndThrow"] = TestFinallyWithCatchAndThrow;
            this.Tests["TestCustomExceptionCatching"] = TestCustomExceptionCatching;
            this.Tests["TestExceptionRethrowing"] = TestExceptionRethrowing;
            this.Tests["TestFinallyWithCatchAndRethrow"] = TestFinallyWithCatchAndRethrow;
        }       

        private static void TestSimpleThrow()
        {
            try
            {
                throw new CsException("Ok");
            }
            catch (CsException ex)
            {
                Assert("Ok", ex.Message);
            }
        }

        private static void TestFinally()
        {
            string s = "a";
            try
            {
                s += "b";
            }
            finally
            {
                s += "c";
            }

            Assert("abc", s);
        }

        private static void TestFinallyWithCatch()
        {
            string s = "a";
            try
            {
                s += "b";
            }
            catch
            {
                s += "x";
            }
            finally
            {
                s += "c";
            }

            Assert("abc", s);
        }

        private static void TestFinallyWithCatchAndExceptionType()
        {
            string s = "a";
            try
            {
                s += "b";
            }
            catch (CsException)
            {
                s += "x";
            }
            finally
            {
                s += "c";
            }

            Assert("abc", s);
        }

        private static void TestFinallyWithCatchAndThrow()
        {
            string s = "a";
            try
            {
                s += "b";
                throw new CsException("Error");
// Disable warning for unreachable code, as it is the purpose to test that the resulting lua code does not execute the rest of the block.
#pragma warning disable
                s += "x";
#pragma warning restore

            }
            catch (CsException)
            {
                s += "c";
            }
            finally
            {
                s += "d";
            }

            Assert("abcd", s);
        }

        private static void TestCustomExceptionCatching()
        {
            string s = "a";
            try
            {
                s += "b";
                throw new CustomException("Error");
            }            
            catch (CustomException)
            {
                s += "c";
            }
            catch (CsException)
            {
                s += "x";
            }
            finally
            {
                s += "d";
            }

            Assert("abcd", s);
        }

        private static void TestExceptionRethrowing()
        {
            string s = "a";
            try {
                try
                {
                    s += "b";
                    throw new CsException("Error");
                }
                catch (CustomException)
                {
                    s += "x";
                }
            }
            catch (CsException)
            {
                s += "c";
            }

            Assert("abc", s);
        }

        private static void TestFinallyWithCatchAndRethrow()
        {
            string s = "a";
            try
            {
                try
                {
                    s += "b";
                    throw new CsException("Error");
                }
                catch (CustomException)
                {
                    s += "x";
                }
                finally
                {
                    s += "c";
                }
            }
            catch (CsException)
            {
                s += "d";
            }

            Assert("abcd", s);
        }
    }
}
