namespace GHF.Model.MSP
{
    using CsLua.Collection;

    public class MspRequestStrategy
    {
        private CsLuaList<string> nameOnly = new CsLuaList<string>()
        {
            MSPFieldNames.Name
        };

        public CsLuaList<string> GetFieldsToRequest(PlayerActivity activity)
        {
            return nameOnly;
        }
    }
}
