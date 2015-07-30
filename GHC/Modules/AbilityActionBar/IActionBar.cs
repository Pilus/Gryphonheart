namespace GHC.Modules.AbilityActionBar
{
    using System;
    using BlizzardApi.WidgetInterfaces;

    public interface IActionBar
    {
        void AddButton(string id, string iconPath, Action<string> clickFunc, Action<string, IGameTooltip> tooltipFunc);
        void RemoveButton(string id);
        void SetCooldown(string id, double startTime, int duration);
        void SetCount(string id, int count);
        void Show();
        void Hide();
    }
}