

namespace GH.Menu.Objects.Panel
{
    using System.Collections.Generic;
    using Line;
    using Page;

    public class PanelProfile : PageProfile, IObjectProfile
    {
        public PanelProfile(ObjectAlign align, string label)
        {
            this.align = align;
            this.label = label;
        }

        public PanelProfile(ObjectAlign align)
        {
            this.align = align;
        }
        public string type { get { return PanelObject.Type; } }
        public string label { get; set; }
        public ObjectAlign align { get; set; }

        public bool canCollapse { get; set; }
        public List<LineProfile> subLines { get; set; }
    }
}
