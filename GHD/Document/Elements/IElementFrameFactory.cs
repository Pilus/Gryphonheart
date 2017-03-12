using GHD.Document.Flags;

namespace GHD.Document.Elements
{
    public interface IElementFrameFactory
    {
        IElementFrame Create(IFlags flags);
    }
}