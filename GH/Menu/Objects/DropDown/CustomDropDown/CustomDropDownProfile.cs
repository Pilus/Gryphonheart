
namespace GH.Menu.Objects.DropDown.CustomDropDown
{
    using System;
    using System.Collections.Generic;

    public class CustomDropDownProfile : IObjectProfileWithText
    {
        public string type { get { return CustomDropDownObject.Type; } }
        public string label { get; set; } 
        public ObjectAlign align { get; set; }

        public const string texture = "tooltip";
        public bool returnIndex;
        public string text { get; set; }
        public Action OnSelect;
        public Func<IEnumerable<DropDownData>> dataFunc;
        public IEnumerable<object> data;
        public double? width;
        public bool outputOnly;
        public Action OnLoad;
        public string tooltip { get; set; }
    }

    
}
