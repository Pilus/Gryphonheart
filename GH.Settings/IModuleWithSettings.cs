
namespace GH.Settings
{
    using System;
    using GH.Menu.Containers.Page;
    using GH.Utils.Modules;

    public interface IModuleWithSettings : IModule
    {
        SettingIds SettingId { get; }
        void ApplySetting(ISetting setting, Action<ISetting> changeSetting);
        ISetting GetDefaultSetting();
        PageProfile ProvideSettingsMenuPageProfile();
        ISetting GetSettingFromSettingMenuPage(IPage page);
    }
}