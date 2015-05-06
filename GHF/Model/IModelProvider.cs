namespace GHF.Model
{
    using GH.ObjectHandling;

    public interface IModelProvider
    {
        IIdObjectList<IProfile, string> AccountProfiles { get; } 
    }
}