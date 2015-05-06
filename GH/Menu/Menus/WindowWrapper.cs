namespace GH.Menu.Menus
{
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    public class WindowWrapper : IGHM_Window
    {
        private readonly IGHM_Window inner;

        public WindowWrapper()
        {
            this.inner = (IGHM_Window)FrameUtil.FrameProvider.CreateFrame(FrameType.Frame, null, Global.UIParent, "GHM_Window");
            this.Frame = SetSelf(this.inner);
            this.BgFrame = SetSelf(this.inner.BgFrame);
            this.BgFrame2 = SetSelf(this.inner.BgFrame2);
            this.TopBgFrame = SetSelf(this.inner.TopBgFrame);
            this.TitleBar = SetSelf(this.inner.TitleBar);

        }

        private static IFrame SetSelf(object frame)
        {
            return (IFrame)FrameUtil.FrameProvider.AddSelfReferencesToNonCsFrameObject(frame);
        }

        public bool settingUp
        {
            get { return this.inner.settingUp; }
            set { this.inner.settingUp = value; }
        }

        public IFrame Frame { get; set; }

        public IFrame menu
        {
            get { return this.inner.menu; }
            set { this.inner.menu = value; }
        }

        public void SetDevMode(bool devModeEnabled)
        {
            this.inner.SetDevMode(devModeEnabled);
        }

        public void SetContent(IFrame menu)
        {
            this.inner.SetContent(menu.self);
        }

        public void SetTitle(string title)
        {
            this.inner.SetTitle(title);
        }

        public void SetIcon(string iconPath)
        {
            this.inner.SetIcon(iconPath);
        }

        public IFrame BgFrame { get; set; }

        public IFrame BgFrame2 { get; set; }

        public IFrame TopBgFrame { get; set; }

        public IFrame TitleBar { get; set; }

        public void AnimatedShow()
        {
            this.inner.AnimatedShow();
        }


        public void SetWidth(double width)
        {
            this.inner.SetWidth(width);
        }

        public void SetHeight(double height)
        {
            this.inner.SetHeight(height);
        }

        public void SetFrameStrata(FrameStrata strata)
        {
            this.inner.SetFrameStrata(strata);
        }


        public void Show()
        {
            this.inner.Show();
        }

        public void ClearAllPoints()
        {
            this.inner.ClearAllPoints();
        }

        public void SetPoint(FramePoint point, double xOfs, double yOfs)
        {
            this.inner.SetPoint(point, xOfs, yOfs);
        }
    }
}