namespace GHC.Modules.AbilityActionBar
{
    using System;
    using BlizzardApi.WidgetInterfaces;

    public interface IActionBar
    {
        void AddButton(string id, string iconPath, Action<string> clickFunc, Action<string, IGameTooltip> tooltipFunc, Func<string, ICooldownInfo> cooldownInfoFunc);
        void RemoveButton(string id);
        void SetCount(string id, int count);
        void Show();
        void Hide();
    }
}