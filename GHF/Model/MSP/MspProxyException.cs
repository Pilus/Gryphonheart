namespace GHF.Model.MSP
{
    using GH;

    public class MspProxyException : BaseException
    {
        public MspProxyException(string msg, params object[] args) : base(msg, args)
        {
        }
    }
}