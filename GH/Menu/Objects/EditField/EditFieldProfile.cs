namespace GH.Menu.Objects.EditField
{
    using System;

    public class EditFieldProfile : IObjectProfileWithText
    {
        public string type { get { return "EditField"; } }

        public string label { get; set; }

        public ObjectAlign align { get; set; }

        public double? width { get; set; }

        public double? height { get; set; }

        public Action<string> OnLoad { get; set; }

        public bool outputOnly { get; set; }

        public string text { get; set; }

        public string tooltip { get; set; }
    }
}
