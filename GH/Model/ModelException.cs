namespace GH.Model
{
    public class ModelException : BaseException
    {
        public ModelException(string msg, params object[] args) : base(msg, args)
        {

        }
    }
}