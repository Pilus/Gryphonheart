

namespace GH.Menu.Menus
{
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    public interface IGHM_Window
    {
        bool settingUp { get; set; }
        IFrame menu { get; set; }
        void SetDevMode(bool devModeEnabled);
        void SetContent(IFrame menu);
        void SetTitle(string title);
        void SetIcon(string iconPath);
        IFrame BgFrame { get; set; }
        IFrame BgFrame2 { get; set; }
        IFrame TopBgFrame { get; set; }
        IFrame TitleBar { get; set; }
        void AnimatedShow();


        void SetWidth(double width);
        void SetHeight(double height);
        void SetFrameStrata(FrameStrata strata);

        IFrame Frame { get; set; }
        void Show();
        void ClearAllPoints();
        void SetPoint(FramePoint point, double xOfs, double yOfs);
    }
}
