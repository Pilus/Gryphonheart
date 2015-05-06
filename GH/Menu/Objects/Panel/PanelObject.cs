
namespace GH.Menu.Objects.Panel
{
    using System;
    using BlizzardApi;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua;
    using Line;
    using Lua;
    using Page;

    public class PanelObject : BaseObject, IMenuContainer
    {
        private readonly PanelProfile profile;
        private IPage innerPage;
        private IMenuContainer parent;
        private IFrame parentFrame;
        private LayoutSettings settings;
        private double borderSize = 0;
        private double extraTopSize = 0;
        private string name;

        public PanelObject(PanelProfile profile, IMenuContainer parent, LayoutSettings settings)
            : base(profile, parent, settings)
        {
            this.profile = profile;
            this.parent = parent;
            this.parentFrame = parent.Frame;
            this.settings = settings;
            this.name = UniqueName(Type);
            this.CreateFrame();
        }

        public static PanelObject Initialize(IObjectProfile profile, IMenuContainer parent, LayoutSettings settings)
        {
            return new PanelObject((PanelProfile) profile, parent, settings);
        }

        public static string Type = "Panel";

        public override void SetPosition(double xOff, double yOff, double width, double height)
        {
            this.Frame.SetHeight(height);
            this.Frame.SetWidth(width);
            this.Frame.SetPoint(FramePoint.TOPLEFT, this.parentFrame, FramePoint.TOPLEFT, xOff, -0);
            this.innerPage.SetPosition(
                this.borderSize,
                this.borderSize + this.extraTopSize,
                width - (this.borderSize * 2),
                height - (this.borderSize * 2 + this.extraTopSize));
        }

        public override double? GetPreferredHeight()
        {
            return this.innerPage.GetPreferredHeight() + this.borderSize * 2 + this.extraTopSize;
        }

        public override double? GetPreferredWidth()
        {
            return this.innerPage.GetPreferredWidth() + this.borderSize * 2;
        }

        public override object GetValue()
        {
            return null;
        }

        public override void Force(object value)
        {
        }

        private void CreateFrame()
        {
            this.Frame = FrameUtil.FrameProvider.CreateFrame(FrameType.Frame, this.name, this.parentFrame) as IFrame;
            this.Frame.SetFrameLevel(this.parentFrame.GetFrameLevel() + 1);
            this.innerPage = new Page(this.profile, this.Frame, this.settings, 1);
        }

        public void ForceLabel(string label, object value)
        {
            this.innerPage.ForceLabel(label, value);
        }

        public object GetLabel(string label)
        {
            return null;
        }

        public IMenuObject GetLabelFrame(string label)
        {
            return this.innerPage.GetLabelFrame(label);
        }

        public void AddElement(int lineIndex, IObjectProfile profile)
        {
            this.innerPage.AddElement(lineIndex, profile);
        }

        public void RemoveElement(string label)
        {
            this.innerPage.RemoveElement(label);
        }
    }
}
