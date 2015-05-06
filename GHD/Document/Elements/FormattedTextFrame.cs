

namespace GHD.Document.Elements
{
    using BlizzardApi;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Flags;

    public class FormattedTextFrame
    {
        private static int frameCount;

        private readonly IFrame frame;
        private readonly IFontString label;

        public FormattedTextFrame(IFlags flags)
        {
            frameCount++;
            var name = GenerateFrameName();
            this.frame = (IFrame)FrameUtil.FrameProvider.CreateFrame(FrameType.Frame, name);
            this.label = this.frame.CreateFontString(name + "Label", Layer.BORDER);
            this.label.SetAllPoints(this.frame);
            this.frame.SetHeight(flags.FontSize);
            this.label.SetFont(flags.Font, flags.FontSize);
            this.label.SetJustifyH(JustifyH.LEFT);  
        }

        public void SetText(string text, double width)
        {
            this.frame.SetWidth(width);
            this.label.SetText(text);
        }

        public IRegion Region
        {
            get { return this.frame; }
        }

        private static string GenerateFrameName()
        {
            const string name = "FormattedTextFrame";
            var i = 1;
            while (FrameUtil.FrameProvider.GetFrameByGlobalName(name + i) != null)
            {
                i++;
            }
            return name + i;
        }
    }
}
