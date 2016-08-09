namespace GHF.Model.MSP
{
    using GH.Utils;

    public class MspProxyException : BaseException
    {
        public MspProxyException(string msg, params object[] args) : base(msg, args)
        {
        }
    }
}