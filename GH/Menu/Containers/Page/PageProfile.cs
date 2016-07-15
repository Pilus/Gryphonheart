
namespace GH.Menu.Objects.Page
{
    using System.Collections.Generic;
    using Containers;
    using Line;

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