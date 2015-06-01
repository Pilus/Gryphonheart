
namespace GHG.Model
{
    using CsLua;
    using Lua;

    [System.Serializable]
    public class GroupMember
    {
        public CsLuaGuid Guid
        {
            get;
            private set;
        }

        public string Name
        {
            get;
            set;
        }

        public CsLuaGuid RankGuid
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

        public GroupMember(CsLuaGuid guid, string name, CsLuaGuid rankGuid)
        {
            this.Guid = guid;
            this.Name = name;
            this.RankGuid = rankGuid;
            this.PublicNote = string.Empty;
            this.OfficersNote = string.Empty;
        }
    }
}
