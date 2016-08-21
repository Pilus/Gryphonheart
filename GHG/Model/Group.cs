namespace GHG.Model
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;

    using GH.Menu;

    public class Group
    {
        private readonly Guid guid;
        private readonly List<LogEvent> logEvents;

        private readonly List<GroupMember> members;
        private readonly List<GroupRank> ranks;
        private bool cryptatedDataInitialized = false;

        private bool deleted;
        private double version;

        public Group()
        {
            this.guid = Guid.NewGuid();
            this.Name = string.Empty;
            this.Icon = string.Empty;
            this.members = new List<GroupMember>();
            this.ranks = new List<GroupRank>();
            this.logEvents = new List<LogEvent>();
            this.deleted = true; // temp to stop warning
        }

        public Guid Guid
        {
            get { return this.guid; }
        }

        public string Name { get; set; }

        public string Icon { get; set; }

        public string ChatName { get; set; }

        public string ChatHeader { get; set; }

        public Color ChatColor { get; set; }

        public string[] ChatSlashCommads { get; set; }

        public double Version
        {
            get { return this.version; }
        }

        public bool CanRead()
        {
            return this.cryptatedDataInitialized && !(this.deleted);
        }

        public void UpdateVersion()
        {
            this.version = Global.Api.GetTime();
        }

        public GroupMember GetMember(Guid guid)
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

        public bool IsPlayerMemberOfGroup(Guid guid)
        {
            return this.members.Where(m => m.Guid.Equals(guid)).Any();
        }

        public bool IsPlayerMemberOfGroup(string name)
        {
            return this.members.Where(m => m.Name.Equals(name)).Any();
        }

        public void AddMember(Guid guid, string name)
        {
            this.AddMember(guid, name, this.ranks.Last().Guid);
        }

        public void AddMember(Guid guid, string name, Guid rankGuid)
        {
            this.members.Add(new GroupMember(guid, name, rankGuid));
            this.logEvents.Add(new LogEvent(LogEventType.Invite, Global.Api.UnitName(UnitId.player), new[] {this.Name}));
        }

        public void RemoveMember(Guid guid)
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

        public GroupRank GetRank(Guid guid)
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

            throw new Exception("Rank not found.");
        }

        public int GetRankIndex(Guid rankGuid)
        {
            for (int i = 1; i <= this.ranks.Count; i++)
            {
                if (this.ranks[i].Guid.Equals(rankGuid))
                {
                    return i;
                }
            }

            throw new Exception("Rank not found.");
        }

        public GroupRank GetRankOfMember(Guid memberGuid)
        {
            GroupMember member = this.GetMember(memberGuid);
            return this.GetRank(member.RankGuid);
        }

        public void SetRankOfMember(Guid memberGuid, Guid rankGuid)
        {
            GroupMember member = this.GetMember(memberGuid);
            if (member == null)
            {
                throw new Exception("Member not found in group.");
            }

            Guid oldRankGuid = member.RankGuid;
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

            //this.members.Where(m => m.RankGuid.Equals(rank.Guid)).ForEach(m => m.RankGuid = replacementRank.Guid); // Commented out to to cslua issue

            this.ranks.Remove(rank);
        }

        #endregion
    }
}