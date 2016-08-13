namespace GHF.Model
{
    using GH.Integration;
    using GH.Utils.Entities.Storage;

    using GHF.Model.MSP;

    public interface IModelProvider
    {
        IEntityStore<Profile, string> AccountProfiles { get; } 
        IAddOnIntegration Integration { get; }
        MSPProxy Msp { get; }
        PublicProfile GetPublicProfile(string characterName);
    }
}