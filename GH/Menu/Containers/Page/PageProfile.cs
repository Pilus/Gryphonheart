
namespace GH.Menu.Objects.Page
{
    using CsLua.Collection;
    using Line;

    public class PageProfile : CsLuaList<LineProfile>
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