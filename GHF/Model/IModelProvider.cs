namespace GHF.Model
{
    using GH.Integration;
    using GH.ObjectHandling;
    using GH.ObjectHandling.Storage;

    public interface IModelProvider
    {
        IObjectStore<Profile, string> AccountProfiles { get; } 
        IAddOnIntegration Integration { get; }
    }
}