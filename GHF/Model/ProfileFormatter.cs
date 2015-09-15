namespace GHF.Model
{
    public class ProfileFormatter
    {
        public string GetFullName(Profile profile)
        {
            return profile.FirstName + 
                (profile.MiddleNames == null ? "" : (" " + profile.MiddleNames)) +
                (profile.LastName == null ? "" : (" " + profile.LastName));
        } 
    }
}