namespace GHD.Document.AltElements
{
    using GHD.Document.Containers;
    using GHD.Document.Flags;

    public interface IElement
    {
        IElement Prev { get; set; }

        IElement Next { get; set; }

        IGroup Group { get; set; }

        IFlags Flags { get; }
    }
}