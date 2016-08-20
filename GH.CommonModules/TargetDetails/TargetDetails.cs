namespace GH.CommonModules.TargetDetails
{ 
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Runtime.Remoting.Messaging;

    using BlizzardApi.EventEnums;
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;
    using GH.CommonModules.QuickButtonCluster;
    using GH.Menu.Containers.Menus;
    using GH.Menu.Containers.Page;
    using GH.Settings;
    using GH.Utils.Entities.Storage;
    using GH.Utils.Modules;
    
    public class TargetDetails : SingletonModule, IModuleWithSettings
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
            this.button.SetIcon(@"GH\Texture\GhRoundIcon");
            this.button.ClickCallback = this.OnClick;
            this.button.Button.Hide();
            var eventListener = new GameEventListener();
            eventListener.RegisterEvent(UnitInfoEvent.PLAYER_TARGET_CHANGED, this.OnTargetChange);
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

        public SettingIds SettingId => TargetDetailsButtonPosition.SettingId;

        public void ApplySetting(ISetting setting, Action<ISetting> changeSetting)
        {
            var buttonPosition = (TargetDetailsButtonPosition)setting;
            this.button.SetPosition(buttonPosition.XPosition, buttonPosition.YPosition);
            this.button.PositionChangeCallback = (newX, newY) =>
            {
                buttonPosition.XPosition = newX;
                buttonPosition.YPosition = newY;
                changeSetting(buttonPosition);
            };
        }

        public ISetting GetDefaultSetting()
        {
            var targetFrame = Global.Api.GetGlobal("TargetFrame");
            // TODO: Calculate the default position based on the target frame.
            return new TargetDetailsButtonPosition() { XPosition = 200, YPosition = -100, };
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
            return new MenuProfile("GH_TargetDetailsMenu", 400, () => { })
            {
                theme = MenuThemeType.TabTheme,
            };
        }

        

        public PageProfile ProvideSettingsMenuPageProfile()
        {
            throw new NotImplementedException();
        }

        public ISetting GetSettingFromSettingMenuPage(IPage page)
        {
            throw new NotImplementedException();
        }
    } 
}