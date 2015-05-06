
namespace GHG.Model
{
    using CsLua;
    using Lua;

    [System.Serializable]
    public class GroupMember
    {
        public WoWGuid Guid
        {
            get;
            private set;
        }

        public string Name
        {
            get;
            set;
        }

        public WoWGuid RankGuid
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

        public GroupMember(WoWGuid guid, string name, WoWGuid rankGuid)
        {
            this.Guid = guid;
            this.Name = name;
            this.RankGuid = rankGuid;
            this.PublicNote = string.Empty;
            this.OfficersNote = string.Empty;
        }
    }
}
