namespace Grinder.View.Xml
{
    using BlizzardApi.WidgetInterfaces;

    public interface IGrinderTrackingRow : IFrame
    {
        ITexture IconTexture { get; }
        IFontString Name { get; }
        IFontString Amount { get; }
        IFontString Velocity { get; }
        IButton ResetButton { get; }
        IButton RemoveButton { get; }
        IEntityId Id { get; set; }
    }
}
