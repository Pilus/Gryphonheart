
namespace GH.Menu.Objects
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLuaFramework.Wrapping;
    using GH.Menu.Theme;
    using Lua;

    public class BaseObjectWithTextLabel : BaseObjectWithInnerObject
    {
        private const double GabUnderText = -5.0;

        //private readonly IObjectProfileWithText profile;
        private readonly ITextLabelWithTooltip textLabel;

        public BaseObjectWithTextLabel(IWrapper wrapper) : base(wrapper)
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

        public override void ApplyTheme(IMenuTheme theme)
        {
            // TODO: Set text color when available in theme.
            base.ApplyTheme(theme);
        }

        public override double? GetPreferredWidth()
        {
            var innerPreferredWidth = this.Inner.GetPreferredWidth();
            if (innerPreferredWidth != null)
            {
                return LuaMath.max((double)innerPreferredWidth, this.textLabel.GetWidth());
            }
            return null;
        }

        public override double? GetPreferredHeight()
        {
            var innerPreferredHeight = this.Inner.GetPreferredHeight();
            if (innerPreferredHeight != null)
            {
                return innerPreferredHeight + this.textLabel.GetHeight() + GabUnderText;
            }
            return null;
        }

        public override double GetPreferredCenterY()
        {
            return this.Inner.GetPreferredCenterY() + this.textLabel.GetHeight() + GabUnderText;
        }

        public override void SetPosition(IFrame parent, double xOff, double yOff, double width, double height)
        {
            this.Frame.SetParent(parent);
            this.Frame.SetWidth(width);
            this.Frame.SetHeight(height);
            this.Frame.SetPoint(FramePoint.TOPLEFT, parent, FramePoint.TOPLEFT, xOff, -yOff);

            var textLabelHeight = this.textLabel.GetHeight() + GabUnderText;
            this.Inner.SetPosition(this.Frame, xOff, yOff + textLabelHeight, width, height - textLabelHeight);
        }
    }
}
