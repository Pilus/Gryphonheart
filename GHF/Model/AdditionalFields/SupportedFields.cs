namespace GHF.Model.AdditionalFields
{
    using System.Collections.Generic;
    using MSP;

    public class SupportedFields
    {
        public List<IField> Fields = new List<IField>()
        {
            new TextField("house", MSPFieldNames.HouseName, "House Name"),
            new TextField("nick", MSPFieldNames.NickName, "Nick Name"),
            new TextField("title", MSPFieldNames.Title, "Title"),
            new TextField("race", MSPFieldNames.Title, "Race"),
            new TextField("currently", MSPFieldNames.Currently, "Current looks"),
            new TextField("age", MSPFieldNames.Age, "Age"),
            new TextField("eyeColor", MSPFieldNames.EyeColour, "Eye color"),
            new TextField("height", MSPFieldNames.Height, "Height"),
            new TextField("weight", MSPFieldNames.Weight, "Weight"),
            new TextField("motto", MSPFieldNames.Motto, "Motto"),
            new TextField("home", MSPFieldNames.Home, "Home"),
            new TextField("birthplace", MSPFieldNames.Birthplace, "Birthplace"),
        };
    }
}