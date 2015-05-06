

namespace GH.Menu.Objects.DropDown
{
    using System;

    public struct DropDownData
    {
        public string text;
        public string value;
        public bool disabled;
        public Action onSelect;
    }
}
