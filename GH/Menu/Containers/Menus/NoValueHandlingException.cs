namespace GH.Menu.Menus
{
    public class NoValueHandlingException : BaseException
    {
        public NoValueHandlingException() : base("The object does not handle Get or Set of Value.")
        {
            
        }
    }
}