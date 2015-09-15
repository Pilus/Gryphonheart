
namespace GH.Model.Defaults
{
    using BlizzardApi.Global;
    using GH.ObjectHandling;
    using GH.Presenter;
    using ObjectHandling.Storage;

    public static class DefaultSettings
    {
        public static void AddToModel(IObjectStoreWithDefaults<ISetting, SettingIds> settingsStore)
        {
            settingsStore.SetDefault(new Setting(SettingIds.ButtonPosition, new double[] { Global.Frames.UIParent.GetWidth() / 2, Global.Frames.UIParent.GetHeight() / 2 }));

            settingsStore.SetDefault(new Setting(SettingIds.QuickButtonShowAnimation, ClusterButtonAnimationType.Instant));
            settingsStore.SetDefault(new Setting(SettingIds.QuickButtonHideAnimation, ClusterButtonAnimationType.Instant));
        }
    }
}
