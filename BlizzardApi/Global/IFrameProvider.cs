
namespace BlizzardApi.Global
{
    using WidgetEnums;
    using WidgetInterfaces;

    public interface IFrameProvider
    {
        IUIObject CreateFrame(FrameType frameType);

        IUIObject CreateFrame(FrameType frameType, string name);

        IUIObject CreateFrame(FrameType frameType, string name, IFrame parent);

        IUIObject CreateFrame(FrameType frameType, string name, IFrame parent, string inherits);

        IUIObject GetMouseFocus();
    }
}
