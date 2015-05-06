

namespace GH.Menu.Objects.Toolbar
{
    using CsLua.Collection;

    public class ToolbarPageProfile : CsLuaList<ToolbarCatagoryProfile>
    {
        public ToolbarPageProfile(string name)
        {
            this.name = name;
        }

        public string name { get; set; }
    }
}
