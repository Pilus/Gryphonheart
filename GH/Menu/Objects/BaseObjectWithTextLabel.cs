
namespace GH.Menu.Objects
{
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Debug;
    using Lua;

    public class BaseObjectWithTextLabel : BaseObjectWithInnerObject
    {
        private const double GabUnderText = -5.0;

        //private readonly IMenuObject innerObject;
        //private readonly IObjectProfileWithText profile;
        private readonly ITextLabelWithTooltip textLabel;

        public BaseObjectWithTextLabel() : base()
        {
            this.textLabel = (ITextLabelWithTooltip)Global.FrameProvider.CreateFrame(FrameType.Frame, "$parentLabel", this.Frame, "GH_TextLabel_Template");
            this.textLabel.SetPoint(FramePoint.TOPLEFT, 0, 0);
        }

        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(profile, handler);
            var textProfile = (IObjectProfileWithText)profile;
            this.textLabel.Label.SetText(textProfile.text);
            this.textLabel.Tooltip = textProfile.tooltip;
        }

        public override double? GetPreferredWidth()
        {
            var innerPreferredWidth = base.GetPreferredWidth();
            if (innerPreferredWidth != null)
            {
                return LuaMath.max((double)innerPreferredWidth, this.textLabel.GetWidth());
            }
            return null;
        }

        public override double? GetPreferredHeight()
        {
            var innerPreferredHeight = base.GetPreferredHeight();
            if (innerPreferredHeight != null)
            {
                return innerPreferredHeight + this.textLabel.GetHeight() + GabUnderText;
            }
            return null;
        }

        public double GetPreferredCenterY()
        {
            return this.Content.FirstOrDefault().GetPreferredCenterY() + this.textLabel.GetHeight() + GabUnderText;
        }

        public override void SetPosition(IFrame parent, double xOff, double yOff, double width, double height)
        {
            this.Frame.SetParent(parent);
            this.Frame.SetWidth(width);
            this.Frame.SetHeight(height);
            this.Frame.SetPoint(FramePoint.TOPLEFT, parent, FramePoint.TOPLEFT, xOff, -yOff);

            var textLabelHeight = this.textLabel.GetHeight() + GabUnderText;
            this.Content.FirstOrDefault().SetPosition(this.Frame, xOff, yOff + textLabelHeight, width, height - textLabelHeight);
        }
    }
}
