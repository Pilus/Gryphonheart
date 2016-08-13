namespace GH.Menu.Containers.Menus
{
    using GH.Utils;

    public class NoValueHandlingException : BaseException
    {
        public NoValueHandlingException() : base("The object does not handle Get or Set of Value.")
        {
            
        }
    }
}