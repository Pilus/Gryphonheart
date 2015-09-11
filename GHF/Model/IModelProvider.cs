namespace GHF.Model
{
    using GH.Integration;
    using GH.ObjectHandling;

    public interface IModelProvider
    {
        IIdObjectList<Profile, string> AccountProfiles { get; } 
        IAddOnIntegration Integration { get; }
    }
}