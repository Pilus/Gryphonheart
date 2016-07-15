namespace GHF.Model.MSP
{
    using System.Collections.Generic;

    public class MspRequestStrategy
    {
        private List<string> nameOnly = new List<string>()
        {
            MSPFieldNames.Name
        };

        public List<string> GetFieldsToRequest(PlayerActivity activity)
        {
            return nameOnly;
        }
    }
}
