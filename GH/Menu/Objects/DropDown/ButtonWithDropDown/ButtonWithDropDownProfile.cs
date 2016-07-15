

namespace GH.Menu.Objects.DropDown.ButtonWithDropDown
{
    using System;
    using System.Collections.Generic;
    using Button;

    public class ButtonWithDropDownProfile : ButtonProfile, IObjectProfile
    {
        public new string type { get { return ButtonWithDropDownObject.Type; } }

        public Func<List<DropDownData>> dataFunc;

        public string dropDownTitle;
    }
}
