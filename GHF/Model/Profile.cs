namespace GHF.Model
{
    using System;
    using GH.ObjectHandling;

    [Serializable]
    public class Profile : IIdObject<string>
    {
        public Profile()
        {
            
        }

        public Profile(string playerName, string gameClassName, string gameRace, string gameSex, string guid)
        {
            this.Id = playerName;
            this.FirstName = playerName;
            this.GameClass = gameClassName;
            this.GameRace = gameRace;
            this.GameSex = gameSex;
            this.Guid = guid;
            this.Details = new Details();
        }

        public string Id { get; set; }
        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string MiddleNames { get; set; }

        public string Title { get; set; }

        public string Appearance { get; set; }

        public Details Details { get; set; }

        public string GameClass { get; set; }
        public string GameRace { get; set; }
        public string GameSex { get; set; }
        public string Guid { get; set; }
    }
}