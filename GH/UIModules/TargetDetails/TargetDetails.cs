namespace GH.UIModules.TargetDetails
{
    using System;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetInterfaces;
    using CsLua.Collection;
    using Menu.Menus;
    using Menu.Objects.Page;
    using Misc;
    using Model;
    using ObjectHandling.Storage;
    using Presenter;
    using Texture;

    public class TargetDetails : ISingletonModule
    {
        private const int ButtonSize = 32;
        private const SettingIds PositionSettingIds = SettingIds.TargetDetailsButtonPosition;

        private readonly RoundButton button;
        private readonly CsLuaList<TargetDetailPageInfo> pages;

        private IMenu currentMenu;

        public TargetDetails()
        {
            this.pages = new CsLuaList<TargetDetailPageInfo>();
            this.button = new RoundButton(ButtonSize);
            this.button.SetIcon(TextureResources.GhRoundTarget);
            this.button.ClickCallback = this.OnClick;
        }

        public void LoadSettings(IObjectStoreWithDefaults<ISetting, SettingIds> settings)
        {
            var position = settings.Get(PositionSettingIds).Value as double[];
            this.button.SetPosition(position[0], position[1]);

            this.button.PositionChangeCallback = (newX, newY) =>
            {
                var positionSetting = new Setting(SettingIds.ButtonPosition, new[] { newX, newY });
                settings.Set(PositionSettingIds, positionSetting);
            };
        }

        public void SetDefaults(IObjectStoreWithDefaults<ISetting, SettingIds> settings)
        {
            var targetFrame = (IFrame)Global.Api.GetGlobal("TargetFrame", typeof(IFrame));
            // TODO: Calculate the default position based on the target frame.
            settings.SetDefault(new Setting(PositionSettingIds, new[] { 200, 100 }));
        }

        public void AddPages(CsLuaList<PageProfile> pageProfiles, Func<bool> enabled)
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
                    .Foreach(page => page.Profiles.Foreach(profile.Add));
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