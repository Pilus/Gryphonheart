namespace GH.Menu.Objects.Text
{
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua.Collection;
    using Line;
    using Panel;

    public class TextObject : BaseObject
    {
        private readonly IFontString labelFrame;
        private readonly TextProfile profile;

        private static readonly CsLuaDictionary<TextColor, Color> ColorMapping = new CsLuaDictionary<TextColor, Color>()
        {
            { TextColor.white, new Color(1, 1, 1)},
            { TextColor.black, new Color(0, 0, 0)},
            { TextColor.yellow, new Color(1, 0.82, 0)},
        };

        public TextObject(TextProfile profile, IMenuContainer parent, LayoutSettings settings) : base(profile, parent, settings)
        {
            var frame = (ITextObjectFrame)FrameUtil.FrameProvider.CreateFrame(FrameType.Frame, UniqueName(Type), parent.Frame, "GH_TextObject_Template");
            this.Frame = frame;
            this.labelFrame =
                (IFontString) FrameUtil.FrameProvider.AddSelfReferencesToNonCsFrameObject(frame.Label);
            this.profile = profile;

            this.SetUpFromProfile();
        }

        public static TextObject Initialize(IObjectProfile profile, IMenuContainer parent, LayoutSettings settings)
        {
            return new TextObject((TextProfile)profile, parent, settings);
        }

        public static string Type = "Text";


        private void SetUpFromProfile()
        {
            
            var fontSize = this.profile.fontSize ?? 11;
            var fontPath = this.profile.font ?? "Fonts\\FRIZQT__.TTF";

            this.labelFrame.SetFont(fontPath, fontSize);
            this.labelFrame.SetJustifyH(GetJustifyH(this.profile.align));

            this.labelFrame.SetWordWrap(true);
            this.labelFrame.SetNonSpaceWrap(false);

            var color = ColorMapping[this.profile.color];
            this.labelFrame.SetTextColor(color.R, color.G, color.B);
            this.SetTextAndUpdateSize(this.profile.text);
        }

        private void SetTextAndUpdateSize(string text)
        {
            this.labelFrame.SetText(text);

            if (this.profile.width != null)
            {
                this.Frame.SetWidth((double)this.profile.width);
                this.labelFrame.SetWidth((double)this.profile.width);
                this.Frame.SetHeight(this.labelFrame.GetHeight() + 15);
            }
            else
            {
                this.Frame.SetWidth(this.labelFrame.GetWidth());
                this.Frame.SetHeight(this.labelFrame.GetHeight());
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

        public override object GetValue()
        {
            return this.labelFrame.GetText();
        }

        public override void SetValue(object value)
        {
            this.SetTextAndUpdateSize((string)value);
        }
    }
}