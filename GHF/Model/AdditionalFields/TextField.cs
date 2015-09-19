namespace GHF.Model.AdditionalFields
{
    using GH.Menu.Objects;
    using GH.Menu.Objects.EditBox;

    public class TextField : IField
    {
        public TextField(string id, string mspMapping, string title)
        {
            this.Id = id;
            this.MspMapping = mspMapping;
            this.Title = title;
        }

        public string Id { get; }
        public string MspMapping { get; }
        public string Title { get; }
        public IObjectProfileWithText GenerateProfile(ObjectAlign preferredAlignment)
        {
            return new EditBoxProfile()
            {
                align = preferredAlignment,
                label = this.Id,
                text = this.Title + ":",
            };
        }

        public bool IsWideField()
        {
            return false;
        }
    }
}