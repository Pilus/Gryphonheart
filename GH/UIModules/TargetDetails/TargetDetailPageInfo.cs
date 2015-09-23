namespace GH.UIModules.TargetDetails
{
    using System;
    using CsLua.Collection;
    using Menu.Objects.Page;

    public class TargetDetailPageInfo
    {
        public TargetDetailPageInfo(CsLuaList<PageProfile> profiles, Func<bool> enabled)
        {
            this.Profiles = profiles;
            this.Enabled = enabled;
        }

        public CsLuaList<PageProfile> Profiles { get; private set; } 
        public Func<bool> Enabled { get; private set; }
    }
}