
namespace CsLuaTest.TryCatchFinally
{
    using CsLua;
    class CustomException : CsException
    {
        public CustomException(string msg) : base(msg)
        {

        }
    }
}
