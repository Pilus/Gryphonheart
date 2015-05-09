
namespace GH.Menu.Objects
{
    using BlizzardApi;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Debug;
    using Lua;

    public class BaseObjectWithTextLabel : BaseObjectWithInnerObject
    {
        private const double GabUnderText = -5.0;

        private readonly IMenuObject innerObject;
        private readonly IObjectProfileWithText profile;
        private readonly IMenuContainer parent;
        private readonly ITextLabelWithTooltip textLabel;

        public BaseObjectWithTextLabel(IObjectProfileWithText profile, IMenuContainer parent, LayoutSettings settings, IMenuObject innerObject) : base(innerObject)
        {
            this.innerObject = innerObject;
            this.profile = profile;
            this.parent = parent;
            
            this.Frame = (IFrame)FrameUtil.FrameProvider.CreateFrame(FrameType.Frame, BaseObject.UniqueName("ObjectWithTextLabel"), parent.Frame);
            this.textLabel = (ITextLabelWithTooltip)FrameUtil.FrameProvider.CreateFrame(FrameType.Frame, "$parentLabel", this.Frame, "GH_TextLabel_Template");
            this.textLabel.SetPoint(FramePoint.TOPLEFT, 0, 0);
            this.textLabel.Label.SetText(profile.text);
            this.textLabel.Tooltip = profile.tooltip;

            this.innerObject.Frame.SetParent(this.Frame);
        }

        public override double? GetPreferredWidth()
        {
            var innerPreferredWidth = this.innerObject.GetPreferredWidth();
            if (innerPreferredWidth != null)
            {
                return LuaMath.max((double)innerPreferredWidth, this.textLabel.GetWidth());
            }
            return null;
        }

        public override double? GetPreferredHeight()
        {
            var innerPreferredHeight = this.innerObject.GetPreferredHeight();
            if (innerPreferredHeight != null)
            {
                return innerPreferredHeight + this.textLabel.GetHeight() + GabUnderText;
            }
            return null;
        }

        public override double GetPreferredCenterY()
        {
            return this.innerObject.GetPreferredCenterY() + this.textLabel.GetHeight() + GabUnderText;
        }

        public override void SetPosition(double xOff, double yOff, double width, double height)
        {
            this.Frame.SetWidth(width);
            this.Frame.SetHeight(height);
            this.Frame.SetPoint(FramePoint.TOPLEFT, this.parent.Frame, FramePoint.TOPLEFT, xOff, -yOff);

            var textLabelHeight = this.textLabel.GetHeight() + GabUnderText;
            this.innerObject.SetPosition(0, textLabelHeight, width, height - textLabelHeight);
        }
    }
}
