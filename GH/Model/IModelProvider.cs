

namespace GH.Model
{
    using GH.Integration;
    using GH.ObjectHandling;
    using ObjectHandling.Storage;

    public interface IModelProvider
    {
        IObjectStoreWithDefaults<IQuickButton, string> ButtonStore { get; }
        IObjectStoreWithDefaults<ISetting, SettingIds> Settings { get; }
        bool IsAddOnLoaded(AddOnReference addonReference);
        AddOnIntegration Integration { get; }
    }
}
