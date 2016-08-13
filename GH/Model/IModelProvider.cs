

namespace GH.Model
{
    using GH.Integration;
    using GH.Utils.AddOnIntegration;
    using GH.Utils.Entities.Storage;

    public interface IModelProvider
    {
        IEntityStoreWithDefaults<IQuickButton, string> ButtonStore { get; }
        IEntityStoreWithDefaults<ISetting, SettingIds> Settings { get; }
        bool IsAddOnLoaded(AddOnReference addonReference);
        AddOnIntegration Integration { get; }
    }
}
