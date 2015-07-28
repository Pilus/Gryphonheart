namespace GHC.Modules.AbilityActionBar
{
    using BlizzardApi.WidgetInterfaces;
    using System;

    class ActionButtonItemViewModel
    {
        public string Id;

        public string IconTexture;

        public int Cooldown;

        public Action<string> OnClick;

        public Action<string, IGameTooltip> UpdateTooltip;
    }
}