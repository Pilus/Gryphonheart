
namespace CsLuaTest.TryCatchFinally
{
    using System;
    
    class CustomException : Exception
    {
        public CustomException(string msg) : base(msg)
        {

        }
    }
}
