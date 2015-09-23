namespace GH.UIModules
{
    using Model;
    using ObjectHandling.Storage;

    public interface ISingletonModule
    {
        void LoadSettings(IObjectStoreWithDefaults<ISetting, SettingIds> settings);

        void SetDefaults(IObjectStoreWithDefaults<ISetting, SettingIds> settings);
    }
}