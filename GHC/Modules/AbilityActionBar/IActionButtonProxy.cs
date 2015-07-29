namespace GHC.Modules.AbilityActionBar
{
    using System;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    public interface IActionButtonProxy
    {
        string Id { get; set; }

        void SetCooldown(double startTime, int duration);
        void SetCount(int count);
        void SetDimensions(double width, double height);
        void SetIcon(string iconPath);
        void SetOnClick(Action<string> func);
        void SetPoint(FramePoint point, double xOffs, double yOffs);
        void SetTooltipFunc(Action<string, IGameTooltip> updateFunc);
        void Hide();
        void Show();
        bool IsShown();
    }
}