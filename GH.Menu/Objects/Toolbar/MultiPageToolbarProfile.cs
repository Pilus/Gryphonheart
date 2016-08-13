

namespace GH.Menu.Objects.Toolbar
{
    using System.Collections.Generic;

    public class MultiPageToolbarProfile  : List<ToolbarPageProfile>, IObjectProfile
    {
        public MultiPageToolbarProfile()
        {
            this.align = ObjectAlign.l;
        }

        public string type { get { return "MultiPageToolbar"; } }

        public string label { get; set; }

        public ObjectAlign align { get; set; }
    }
}
