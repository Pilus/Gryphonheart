namespace GH.CommonModules.QuickButtonCluster
{
    using System;
    using BlizzardApi.Global;
    using CsLuaFramework.Wrapping;
    using GH.CommonModules.QuickButtonCluster.ClusterButtonAnimation;
    using GH.Menu.Containers.Page;
    using GH.Settings;
    using GH.Utils.AddOnIntegration;
    using GH.Utils.Modules;
    public class QuickButtonModule : SingletonModule, IModuleWithSettings
    {
        public SettingIds SettingId => QuickButtonSettings.SettingId;

        private readonly QuickButtonSettings defaultSettings;
        private readonly ButtonCluster buttonCluster;

        public QuickButtonModule()
        {
            var uiParent = Global.Frames.UIParent;
            this.defaultSettings = new QuickButtonSettings()
            {
                XLocation = uiParent.GetWidth() * 0.75,
                YLocation = uiParent.GetHeight() * 0.75,
            };
            var addonRegistry = ModuleFactory.ModuleFactorySingleton.GetModule<AddOnRegistry>();
            this.buttonCluster = new ButtonCluster(new ClusterButtonAnimationFactory(), new Wrapper(), addonRegistry);
        }

        public void RegisterDefaultButton(IQuickButton button)
        {
            this.defaultSettings.QuickButtons.Add(button);
        }

        public void ApplySetting(ISetting setting, Action<ISetting> changeSetting)
        {
            this.buttonCluster.ApplySettings((QuickButtonSettings) setting, changeSetting);
        }

        public ISetting GetDefaultSetting()
        {
            return this.defaultSettings;
        }

        public PageProfile ProvideSettingsMenuPageProfile()
        {
            throw new System.NotImplementedException();
        }

        public ISetting GetSettingFromSettingMenuPage(IPage page)
        {
            throw new System.NotImplementedException();
        }
    }
}