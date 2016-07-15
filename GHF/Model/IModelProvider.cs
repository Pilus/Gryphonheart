namespace GHF.Model
{
    using GH.Integration;
    using GH.ObjectHandling.Storage;
    using GHF.Model.MSP;

    public interface IModelProvider
    {
        IObjectStore<Profile, string> AccountProfiles { get; } 
        IAddOnIntegration Integration { get; }
        MSPProxy Msp { get; }
        PublicProfile GetPublicProfile(string characterName);
    }
}