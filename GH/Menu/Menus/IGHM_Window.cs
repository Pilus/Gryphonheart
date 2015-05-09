

namespace GH.Menu.Menus
{
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    public interface IGHM_Window : IFrame
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
    }
}
