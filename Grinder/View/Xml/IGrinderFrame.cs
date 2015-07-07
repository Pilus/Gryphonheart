namespace Grinder.View.Xml
{
    using BlizzardApi.WidgetInterfaces;
    using CsLuaAttributes;

    [ProvideSelf]
    public interface IGrinderFrame : IFrame
    {
        IFontString Label { get; }
        IButton TrackButton { get; }
        IFrame TrackingContainer { get; }
    }
}
