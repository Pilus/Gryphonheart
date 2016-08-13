
namespace GH.Menu.Objects.Button
{
    using System;

    public class ButtonProfile : IObjectProfile
    {
        public string type { get { return ButtonObject.Type; } }
        public string label { get; set; }
        public ObjectAlign align { get; set; }

        public string text { get; set; }

        public bool? compact { get; set; }

        public double? height { get; set; }

        public double? width { get; set; }

        public string tooltip { get; set; }

        public bool? ignoreTheme { get; set; }

        public Action onClick { get; set; }
    }
}
