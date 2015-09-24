
namespace GH.Menu.Objects.Page
{
    using Containers;
    using CsLua.Collection;
    using Line;

    public class PageProfile : CsLuaList<LineProfile>, IContainerProfile<LineProfile>, IMenuRegionProfile
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