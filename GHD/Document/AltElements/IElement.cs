namespace GHD.Document.AltElements
{
    using GHD.Document.Flags;

    public interface IElement
    {
        void Insert(IFlags newFlags, string newText);

        IElement Prev { get; set; }

        IElement Next { get; set; }

        HorizontalGroup Group { get; set; }

        IFlags Flags { get; }
    }
}