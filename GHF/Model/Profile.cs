namespace GHF.Model
{
    using System;
    using System.Collections.Generic;
    using GH.Utils.Entities;

    [Serializable]
    public class Profile : IIdEntity<string>
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
            this.AdditionalFields = new Dictionary<string, string>();
        }

        public string Id { get; set; }
        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string MiddleNames { get; set; }

        public string Appearance { get; set; }

        public string GameClass { get; set; }
        public string GameRace { get; set; }
        public string GameSex { get; set; }
        public string Guid { get; set; }

        public Details Details { get; set; }
        public Dictionary<string, string> AdditionalFields { get; set; }

        public static string GetAdditionalField(Profile profile, string id)
        {
            return profile.AdditionalFields.ContainsKey(id) ? profile.AdditionalFields[id] : null;
        }

        public static void SetAdditionalField(Profile profile, string id, string value)
        {
            if (value == null && profile.AdditionalFields.ContainsKey(id))
            {
                profile.AdditionalFields.Remove(id);
            }
            else
            {
                profile.AdditionalFields[id] = value;
            }
        }
    }
}