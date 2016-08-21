namespace GHF.Model
{
    using GH.Utils.Entities.Storage;

    using GHF.Model.MSP;

    public interface IModelProvider
    {
        IEntityStore<Profile, string> AccountProfiles { get; } 
        MSPProxy Msp { get; }
        PublicProfile GetPublicProfile(string characterName);
    }
}