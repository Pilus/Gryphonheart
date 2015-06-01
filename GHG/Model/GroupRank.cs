
namespace GHG.Model
{
    using CsLua;
    using Lua;

    [System.Serializable]
    public class GroupRank
    {
        public GroupRank(string name, bool isFirst)
        {
            this.Name = name;
            this.Guid = CsLuaGuid.NewGuid();
            if (isFirst)
            {
                this.CanEditRanksAndPermissions = true;
            }
        }


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

        public bool CanEditRanksAndPermissions
        {
            get;
            set;
        }

        public bool CanInvite
        {
            get;
            set;
        }

        public bool CanKickMember
        {
            get;
            set;
        }

        public bool CanPromoteDemote
        {
            get;
            set;
        }

        public bool CanEditOfficersNote
        {
            get;
            set;
        }

        public bool CanViewOfficersNote
        {
            get;
            set;
        }

        public bool CanEditPublicNote
        {
            get;
            set;
        }

        public bool CanViewPublicNote
        {
            get;
            set;
        }

        public bool CanTalkInChat
        {
            get;
            set;
        }

        public bool CanHearChat
        {
            get;
            set;
        }
    }
}
