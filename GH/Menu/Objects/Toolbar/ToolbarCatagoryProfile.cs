

namespace GH.Menu.Objects.Toolbar
{
    using CsLua.Collection;

    public class ToolbarCatagoryProfile : CsLuaList<ToolbarLineProfile>
    {
        public ToolbarCatagoryProfile(string name)
        {
            this.name = name;
        }

        public string name { get; set; }
    }
}
