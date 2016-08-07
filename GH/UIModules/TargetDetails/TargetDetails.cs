namespace GH.UIModules.TargetDetails
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetInterfaces;
    using Menu.Menus;
    using Menu.Objects.Page;
    using Misc;
    using Model;
    using ObjectHandling.Storage;
    using Presenter;
    using Texture;
    using BlizzardApi.EventEnums;
    using BlizzardApi.MiscEnums;

    public class TargetDetails : ISingletonModule
    {
        private const int ButtonSize = 32;
        private const SettingIds PositionSettingIds = SettingIds.TargetDetailsButtonPosition;

        private readonly RoundButton button;
        private readonly List<TargetDetailPageInfo> pages;

        private IMenu currentMenu;

        public TargetDetails()
        {
            this.pages = new List<TargetDetailPageInfo>();
            this.button = new RoundButton(ButtonSize);
            this.button.SetIcon(TextureResources.GhRoundTarget);
            this.button.ClickCallback = this.OnClick;
            this.button.Button.Hide();
            Misc.RegisterEvent(UnitInfoEvent.PLAYER_TARGET_CHANGED, this.OnTargetChange);
        }

        private void OnTargetChange(UnitInfoEvent eventName, object arg)
        {
            this.EvaluateVisibility();
        }

        public void EvaluateVisibility()
        { 
            if (!Global.Api.UnitExists(UnitId.target))
            {
                this.button.Button.Hide();
                return;
            }

            if (this.pages.Any(p => p.Enabled()))
            {
                this.button.Button.Show();
            }
        }

        public void LoadSettings(IObjectStoreWithDefaults<ISetting, SettingIds> settings)
        {
            var position = settings.Get(PositionSettingIds).Value as double[];
            this.button.SetPosition(position[0], position[1]);

            this.button.PositionChangeCallback = (newX, newY) =>
            {
                var positionSetting = new Setting(SettingIds.ButtonPosition, new[] { newX, newY });
                settings.Set(positionSetting);
            };
        }

        public void SetDefaults(IObjectStoreWithDefaults<ISetting, SettingIds> settings)
        {
            var targetFrame = Global.Api.GetGlobal("TargetFrame"); // TODO: Use wrapper
            // TODO: Calculate the default position based on the target frame.
            settings.SetDefault(new Setting(PositionSettingIds, new double[] { 200, 100 }));
        }

        public void AddPages(List<PageProfile> pageProfiles, Func<bool> enabled)
        {
            this.pages.Add(new TargetDetailPageInfo(pageProfiles, enabled));
        }

        private void OnClick()
        {
            if (this.currentMenu == null)
            {
                var profile = GenerateMenuProfile();
                this.pages
                    .Where(page => page.Enabled())
                    .ToList()
                    .ForEach(page => page.Profiles.ForEach(profile.Add));
            }
            else
            {
                this.currentMenu.Hide();
                this.currentMenu = null;
            }
        }

        private static MenuProfile GenerateMenuProfile()
        {
            return new MenuProfile(Misc.GetUniqueGlobalName("TargetDetailsMenu"), 400, () => { })
            {
                theme = MenuThemeType.TabTheme,
            };
        }
        
    }
}