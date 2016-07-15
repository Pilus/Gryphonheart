
namespace GHG.Model
{
    using System;

    [System.Serializable]
    public class GroupMember
    {
        public Guid Guid
        {
            get;
            private set;
        }

        public string Name
        {
            get;
            set;
        }

        public Guid RankGuid
        {
            get;
            set;
        }

        public string PublicNote
        {
            get;
            set;
        }

        public string OfficersNote
        {
            get;
            set;
        }

        public GroupMember(Guid guid, string name, Guid rankGuid)
        {
            this.Guid = guid;
            this.Name = name;
            this.RankGuid = rankGuid;
            this.PublicNote = string.Empty;
            this.OfficersNote = string.Empty;
        }
    }
}
