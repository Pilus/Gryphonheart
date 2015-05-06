namespace GHF.Model
{
    using System;

    [Serializable]
    public class Profile : IProfile
    {
        public Profile(string playerName)
        {
            this.Id = playerName;
            this.FirstName = playerName;
            this.Details = new Details();
        }

        public string Id { get; set; }
        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string MiddleNames { get; set; }

        public string Title { get; set; }

        public string Appearance { get; set; }

        public IDetails Details { get; set; }

        
    }
}