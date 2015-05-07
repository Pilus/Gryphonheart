

namespace GH.Menu.Objects.EditBox
{
    using System;

    public class EditBoxProfile : IObjectProfileWithText
    {
        public string type { get { return EditBoxObject.Type; } }

        public string label { get; set; }

        public ObjectAlign align { get; set; }

        public string text { get; set; }

        public string tooltip { get; set; }

        public double? width { get; set; }


        public bool numbersOnly { get; set; }

        public bool variablesOnly { get; set; }

        public Action<string> OnTextChanged { get; set; }

        public int? size { get; set; }

        public Action OnEnterPressed { get; set; }

        public string startText { get; set; }

        public string texture { get { return "Tooltip"; } }
    }
}
