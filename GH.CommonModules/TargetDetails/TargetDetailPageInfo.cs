namespace GH.CommonModules.TargetDetails
{
    using System;
    using System.Collections.Generic;
    using GH.Menu.Containers.Page;

    public class TargetDetailPageInfo
    {
        public TargetDetailPageInfo(List<PageProfile> profiles, Func<bool> enabled)
        {
            this.Profiles = profiles;
            this.Enabled = enabled;
        }

        public List<PageProfile> Profiles { get; private set; } 
        public Func<bool> Enabled { get; private set; }
    }
}