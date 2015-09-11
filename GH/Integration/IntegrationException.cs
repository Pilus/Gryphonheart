namespace GH.Integration
{
    public class IntegrationException : BaseException
    {
        public IntegrationException(string msg, params object[] args) : base(msg, args)
        {
        }
    }
}
