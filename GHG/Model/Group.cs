namespace GHG.Model
{
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;
    using CsLua;
    using CsLua.Collection;
    using GH;
    using GH.Misc;

    [System.Serializable]
    public class Group
    {
        private readonly CsLuaGuid guid;
        private readonly CsLuaList<LogEvent> logEvents;

        private readonly CsLuaList<GroupMember> members;
        private readonly CsLuaList<GroupRank> ranks;
        private bool cryptatedDataInitialized = false;

        private bool deleted;
        private long version;

        public Group()
        {
            this.guid = CsLuaGuid.NewGuid();
            this.Name = string.Empty;
            this.Icon = string.Empty;
            this.members = new CsLuaList<GroupMember>();
            this.ranks = new CsLuaList<GroupRank>();
            this.logEvents = new CsLuaList<LogEvent>();
            this.deleted = true; // temp to stop warning
        }

        public CsLuaGuid Guid
        {
            get { return this.guid; }
        }

        public string Name { get; set; }

        public string Icon { get; set; }

        public string ChatName { get; set; }

        public string ChatHeader { get; set; }

        public Color ChatColor { get; set; }

        public string[] ChatSlashCommads { get; set; }

        public long Version
        {
            get { return this.version; }
        }

        public bool CanRead()
        {
            return this.cryptatedDataInitialized && !(this.deleted);
        }

        public void UpdateVersion()
        {
            this.version = Misc.GetTimeBasedVersion();
        }

        public GroupMember GetMember(CsLuaGuid guid)
        {
            return this.members.Where(m => m.Guid.Equals(guid)).First();
        }

        #region Members

        public int GetNumMembers()
        {
            return this.members.Count;
        }

        public GroupMember GetMember(int i)
        {
            return this.members[i];
        }

        public bool IsPlayerMemberOfGroup(CsLuaGuid guid)
        {
            return this.members.Where(m => m.Guid.Equals(guid)).Any();
        }

        public bool IsPlayerMemberOfGroup(string name)
        {
            return this.members.Where(m => m.Name.Equals(name)).Any();
        }

        public void AddMember(CsLuaGuid guid, string name)
        {
            this.AddMember(guid, name, this.ranks.Last().Guid);
        }

        public void AddMember(CsLuaGuid guid, string name, CsLuaGuid rankGuid)
        {
            this.members.Add(new GroupMember(guid, name, rankGuid));
            this.logEvents.Add(new LogEvent(LogEventType.Invite, Global.Api.UnitName(UnitId.player), new[] {this.Name}));
        }

        public void RemoveMember(CsLuaGuid guid)
        {
            GroupMember member = this.GetMember(guid);
            this.members.Remove(member);
            this.logEvents.Add(new LogEvent(LogEventType.Remove, Global.Api.UnitName(UnitId.player), new[] { this.Name }));
        }

        #endregion

        #region Ranks

        public void AddRank(string rankName)
        {
            var rank = new GroupRank(rankName, this.ranks.Count == 0);
            this.ranks.Add(rank);
        }

        public GroupRank GetRank(CsLuaGuid guid)
        {
            return this.ranks.Where(r => r.Guid.Equals(guid)).FirstOrDefault();
        }

        public int GetNumRanks()
        {
            return this.ranks.Count;
        }

        public GroupRank GetRank(int i)
        {
            return this.ranks[i];
        }

        public void SetRank(int i, GroupRank rank)
        {
            this.ranks[i] = rank;
        }

        public int GetRankIndex(GroupRank rank)
        {
            for (int i = 1; i <= this.ranks.Count; i++)
            {
                if (this.ranks[i].Equals(rank))
                {
                    return i;
                }
            }

            throw new CsException("Rank not found.");
        }

        public int GetRankIndex(CsLuaGuid rankGuid)
        {
            for (int i = 1; i <= this.ranks.Count; i++)
            {
                if (this.ranks[i].Guid.Equals(rankGuid))
                {
                    return i;
                }
            }

            throw new CsException("Rank not found.");
        }

        public GroupRank GetRankOfMember(CsLuaGuid memberGuid)
        {
            GroupMember member = this.GetMember(memberGuid);
            return this.GetRank(member.RankGuid);
        }

        public void SetRankOfMember(CsLuaGuid memberGuid, CsLuaGuid rankGuid)
        {
            GroupMember member = this.GetMember(memberGuid);
            if (member == null)
            {
                throw new CsException("Member not found in group.");
            }

            CsLuaGuid oldRankGuid = member.RankGuid;
            member.RankGuid = rankGuid;

            LogEventType eventType = this.GetRankIndex(oldRankGuid) >= this.GetRankIndex(rankGuid)
                ? LogEventType.Promote
                : LogEventType.Demote;
            this.logEvents.Add(new LogEvent(eventType, Global.Api.UnitName(UnitId.player), new[] { this.Name }));
        }

        public void DeleteRank(int rankIndex)
        {
            GroupRank rank = this.GetRank(rankIndex);
            GroupRank replacementRank;
            if (rankIndex.Equals(this.ranks.Count))
            {
                replacementRank = this.ranks[rankIndex - 1];
            }
            else
            {
                replacementRank = this.ranks[rankIndex + 1];
            }   

            //this.members.Where(m => m.RankGuid.Equals(rank.Guid)).Foreach(m => m.RankGuid = replacementRank.Guid); // Commented out to to cslua issue

            this.ranks.Remove(rank);
        }

        #endregion
    }
}