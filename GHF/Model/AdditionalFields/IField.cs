namespace GHF.Model.AdditionalFields
{
    using GH.Menu.Objects;

    public interface IField
    {
        string Id { get; }
        string MspMapping { get; }
        string Title { get; }
        IObjectProfileWithText GenerateProfile(ObjectAlign preferredAlignment);
        bool IsWideField();
    }
}