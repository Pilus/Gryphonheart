namespace GH.Model
{
    using System;

    public class ModelException : BaseException
    {
        public ModelException(string msg, params object[] args) : base(msg, args)
        {

        }
    }
}