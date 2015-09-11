

namespace GH.Model
{
    using GH.Integration;
    using GH.ObjectHandling;

    public interface IModelProvider
    {
        IIdObjectListWithDefaults<IQuickButton, string> ButtonList { get; }
        IIdObjectListWithDefaults<ISetting, SettingIds> Settings { get; }
        bool IsAddOnLoaded(AddOnReference addonReference);
    }
}
