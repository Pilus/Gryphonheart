

namespace GH.Menu.Objects.DropDown.ButtonWithDropDown
{
    using System;
    using Button;
    using CsLua.Collection;

    public class ButtonWithDropDownProfile : ButtonProfile, IObjectProfile
    {
        public new string type { get { return ButtonWithDropDownObject.Type; } }

        public Func<CsLuaList<DropDownData>> dataFunc;
    }
}
