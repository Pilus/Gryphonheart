namespace GHD.Document.Elements
{
    using GHD.Document.Flags;

    public interface IElementFactory
    {
        IElement CreateText(IFlags flags, string text);
    }
}