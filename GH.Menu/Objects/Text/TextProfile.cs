

namespace GH.Menu.Objects.Text
{
    using System;

    public class TextProfile : IObjectProfile
    {
        public string type { get { return TextObject.Type; } }
        public string label { get; set; }
        public ObjectAlign align { get; set; }

        public string font { get; set; }

        public string text { get; set; }

        public int? fontSize { get; set; }
        public bool? outline { get; set; }
        public bool? shadow { get; set; }

        public TextColor color { get; set; }

        public double? width { get; set; }

        public double? height { get; set; }
        public Action OnLoad { get; set; }
    }
}
