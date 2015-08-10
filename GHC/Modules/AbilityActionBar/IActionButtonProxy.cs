namespace GHC.Modules.AbilityActionBar
{
    using System;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    public interface IActionButtonProxy
    {
        string Id { get; set; }

        void SetCount(int count);
        void SetHotKey(string hotKeyText);
        void SetDimensions(double width, double height);
        void SetIcon(string iconPath);
        void SetOnClick(Action<string> func);
        void SetGetCooldown(Func<ICooldownInfo> func);
        void SetPoint(FramePoint point, double xOffs, double yOffs);
        void SetTooltipFunc(Action<string, IGameTooltip> updateFunc);
        void Hide();
        void Show();
        bool IsShown();
    }
}