namespace GH.UIModules
{
    using GH.Utils.Entities.Storage;

    using Model;

    public interface ISingletonModule
    {
        void LoadSettings(IObjectStoreWithDefaults<ISetting, SettingIds> settings);

        void SetDefaults(IObjectStoreWithDefaults<ISetting, SettingIds> settings);
    }
}