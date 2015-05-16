

namespace GH.Menu.Objects.DropDown.ButtonWithDropDown
{
    using System;
    using CsLua.Collection;

    public class ButtonWithDropDownProfile : IObjectProfile
    {
        public string type { get { return "ButtonWithDropDown"; } }

        public string label { get; set; }

        public ObjectAlign align { get; set; }

        public string text;

        public bool? compact { get; set; }

        public double? height { get; set; }

        public double? width { get; set; }

        public string tooltip { get; set; }

        public bool? ignoreTheme { get; set; }

        public Func<CsLuaList<DropDownData>> dataFunc;
    }
}
