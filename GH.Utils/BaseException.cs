namespace GH.Utils
{
    using System;

    public class BaseException : Exception
    {
        public BaseException(string msg, params object[] args) : base(string.Format(msg, args))
        {

        }
    }
}