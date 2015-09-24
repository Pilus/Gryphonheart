namespace GH.Menu
{
    public class MenuException : BaseException
    {
        public MenuException(string msg, params object[] args) : base(msg, args)
        {
        }
    }
}