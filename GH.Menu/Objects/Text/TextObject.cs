namespace GH.Menu.Objects.Text
{
    using System.Collections.Generic;
    using BlizzardApi.WidgetEnums;
    using CsLuaFramework.Wrapping;

    public class TextObject : BaseObject
    {
        private const string Template = "GH_TextObject_Template";

        public static string Type = "Text";

        private readonly ITextObjectFrame frame;

        private static readonly Dictionary<TextColor, Color> ColorMapping = new Dictionary<TextColor, Color>()
        {
            { TextColor.white, new Color(1, 1, 1)},
            { TextColor.black, new Color(0, 0, 0)},
            { TextColor.yellow, new Color(1, 0.82, 0)},
        };

        private double? width;

        public TextObject(IWrapper wrapper) : base(Type, FrameType.Frame, Template, wrapper)
        {
            this.frame = (ITextObjectFrame) this.Frame;
        }

        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(profile, handler);
            this.SetUpFromProfile((TextProfile)profile);
        }

        private void SetUpFromProfile(TextProfile profile)
        {
            
            var fontSize = profile.fontSize ?? 11;
            var fontPath = profile.font ?? "Fonts\\FRIZQT__.TTF";

            var label = this.frame.Label;
            label.SetFont(fontPath, fontSize);
            label.SetJustifyH(GetJustifyH(profile.align));

            label.SetWordWrap(true);
            label.SetNonSpaceWrap(false);

            var color = ColorMapping[profile.color];
            label.SetTextColor(color.R, color.G, color.B);
            this.SetTextAndUpdateSize(profile.text);

            this.width = profile.width;
        }

        private void SetTextAndUpdateSize(string text)
        {
            var label = this.frame.Label;
            label.SetText(text);

            if (this.width != null)
            {
                this.Frame.SetWidth((double)this.width);
                label.SetWidth((double)this.width);
                this.Frame.SetHeight(label.GetHeight() + 15);
            }
            else
            {
                this.Frame.SetWidth(label.GetWidth());
                this.Frame.SetHeight(label.GetHeight());
            }
        }

        private static JustifyH GetJustifyH(ObjectAlign align)
        {
            switch (align)
            {
                case ObjectAlign.c:
                    return JustifyH.CENTER;
                case ObjectAlign.r:
                    return JustifyH.RIGHT;
                default:
                    return JustifyH.LEFT;
            }
        }

        public object GetValue()
        {
            return this.frame.Label.GetText();
        }

        public void SetValue(object value)
        {
            this.SetTextAndUpdateSize((string)value);
        }
    }
}