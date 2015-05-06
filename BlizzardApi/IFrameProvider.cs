
namespace BlizzardApi
{
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    public interface IFrameProvider
    {
        IUIObject CreateFrame(FrameType frameType);

        IUIObject CreateFrame(FrameType frameType, string name);

        IUIObject CreateFrame(FrameType frameType, string name, IFrame parent);

        IUIObject CreateFrame(FrameType frameType, string name, IFrame parent, string inherits);

        IUIObject GetFrameByGlobalName(string name);

        IUIObject GetMouseFocus();

        IUIObject AddSelfReferencesToNonCsFrameObject(object obj);
    }
}
