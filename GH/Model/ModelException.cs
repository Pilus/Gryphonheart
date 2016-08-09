namespace GH.Model
{
    using GH.Utils;

    public class ModelException : BaseException
    {
        public ModelException(string msg, params object[] args) : base(msg, args)
        {

        }
    }
}