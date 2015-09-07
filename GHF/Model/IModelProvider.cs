namespace GHF.Model
{
    using GH.ObjectHandling;

    public interface IModelProvider
    {
        IIdObjectList<Profile, string> AccountProfiles { get; } 
    }
}