namespace GHD.Document.Elements
{
    using BlizzardApi.WidgetInterfaces;

    public interface IElementFrame
    {
        IRegion Region { get; }

        void SetText(string text, double width);
    }
}