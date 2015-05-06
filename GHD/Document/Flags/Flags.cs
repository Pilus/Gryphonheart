
namespace GHD.Document.Flags
{
    using GH;

    public class Flags : IFlags
    {
        public string Font { get; set; }
        public int FontSize { get; set; }
        public bool Bold { get; set; }
        public bool UnderLine { get; set; }
        public bool Strikethrough { get; set; }
        public Color Color { get; set; }
        public Color BackgroundColor { get; set; }
        public Alignment Alignment { get; set; }

        public bool Equals(IFlags other)
        {
            return
                this.Bold == other.Bold &&
                this.Strikethrough == other.Strikethrough &&
                this.UnderLine == other.UnderLine &&
                this.Alignment == other.Alignment &&
                this.BackgroundColor.Equals(other.BackgroundColor) &&
                this.Color.Equals(other.Color) &&
                this.Font == other.Font &&
                this.FontSize == other.FontSize;
        }
    }
}
