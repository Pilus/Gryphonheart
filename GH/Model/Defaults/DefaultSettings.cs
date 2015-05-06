
namespace GH.Model.Defaults
{
    using BlizzardApi.Global;
    using GH.ObjectHandling;
    using GH.Presenter;

    public static class DefaultSettings
    {
        public static void AddToModel(IIdObjectListWithDefaults<ISetting, SettingIds> settingsList)
        {
            settingsList.SetDefault(new Setting(SettingIds.ButtonPosition, new double[] { Global.UIParent.GetWidth() / 2, Global.UIParent.GetHeight() / 2 }));

            settingsList.SetDefault(new Setting(SettingIds.QuickButtonShowAnimation, ClusterButtonAnimationType.Instant));
            settingsList.SetDefault(new Setting(SettingIds.QuickButtonHideAnimation, ClusterButtonAnimationType.Instant));
        }
    }
}
