
namespace GH.Menu.Objects.DropDown.CustomDropDown
{
    using System;
    using CsLua.Collection;

    public class CustomDropDownProfile : IObjectProfileWithText
    {
        public string type { get { return CustomDropDownObject.Type; } }
        public string label { get; set; } 
        public ObjectAlign align { get; set; }

        public const string texture = "tooltip";
        public bool returnIndex;
        public string text { get; set; }
        public Action OnSelect;
        public Func<CsLuaList<DropDownData>> dataFunc;
        public CsLuaList<object> data;
        public double? width;
        public bool outputOnly;
        public Action OnLoad;
        public string tooltip { get; set; }
    }

    
}
