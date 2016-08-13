namespace GH.UIModules
{
    using GH.Utils.Entities.Storage;

    using Model;

    public interface ISingletonModule
    {
        void LoadSettings(IEntityStoreWithDefaults<ISetting, SettingIds> settings);

        void SetDefaults(IEntityStoreWithDefaults<ISetting, SettingIds> settings);
    }
}