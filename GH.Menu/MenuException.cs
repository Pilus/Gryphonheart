namespace GH.Menu
{
    using GH.Utils;

    public class MenuException : BaseException
    {
        public MenuException(string msg, params object[] args) : base(msg, args)
        {
        }
    }
}