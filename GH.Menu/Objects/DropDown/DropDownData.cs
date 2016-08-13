

namespace GH.Menu.Objects.DropDown
{
    using System;

    public class DropDownData
    {
        public DropDownData()
        {
            
        }

        public DropDownData(string text, Action select)
        {
            this.text = text;
            this.onSelect = select;
        }

        public string text;
        public string value;
        public bool disabled;
        public Action onSelect;
    }
}
