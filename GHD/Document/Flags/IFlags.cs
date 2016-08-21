

namespace GHD.Document.Flags
{
    using GH;
    using GH.Menu;

    public interface IFlags
    {
        string Font { get; set; }
        int FontSize { get; set; }
        bool Bold { get; set; }
        bool UnderLine { get; set; }
        bool Strikethrough { get; set; }
        Color Color { get; set; }
        Color BackgroundColor { get; set; }
        Alignment Alignment { get; set; }

    }
}
