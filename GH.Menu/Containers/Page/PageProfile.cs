//-----------------------–-----------------------–--------------
// <copyright file="PageProfile.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------
namespace GH.Menu.Containers.Page
{
    using System.Collections.Generic;

    using GH.Menu.Containers.Line;

    public class PageProfile : List<LineProfile>, IContainerProfile<LineProfile>, IMenuRegionProfile
    {
        public PageProfile()
        {
        }

        public PageProfile(string name)
        {
            this.name = name;
        }

        public PageProfile(string name, string help)
        {
            this.name = name;
            this.help = help;
        }

        public string name;

        public string help;
    }
}