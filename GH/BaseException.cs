namespace GH
{
    using CsLua;
    using System;

    public class BaseException : CsException
    {
        public BaseException(string msg, params object[] args) : base(string.Format(msg, args))
        {

        }
    }
}