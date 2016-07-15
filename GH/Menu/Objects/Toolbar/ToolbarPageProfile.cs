

namespace GH.Menu.Objects.Toolbar
{
    using System.Collections.Generic;

    public class ToolbarPageProfile : List<ToolbarCatagoryProfile>
    {
        public ToolbarPageProfile(string name)
        {
            this.name = name;
        }

        public string name { get; set; }
    }
}
