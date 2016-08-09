

namespace GH.Model
{
    using GH.Integration;
    using GH.Utils.Entities.Storage;

    public interface IModelProvider
    {
        IObjectStoreWithDefaults<IQuickButton, string> ButtonStore { get; }
        IObjectStoreWithDefaults<ISetting, SettingIds> Settings { get; }
        bool IsAddOnLoaded(AddOnReference addonReference);
        AddOnIntegration Integration { get; }
    }
}
