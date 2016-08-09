namespace GH.Integration
{
    using GH.Utils;

    public class IntegrationException : BaseException
    {
        public IntegrationException(string msg, params object[] args) : base(msg, args)
        {
        }
    }
}
