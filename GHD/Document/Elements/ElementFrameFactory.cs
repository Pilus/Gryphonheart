namespace GHD.Document.Elements
{
    using GHD.Document.Flags;

    public class ElementFrameFactory : IElementFrameFactory
    { 
        public IElementFrame Create(IFlags flags)
        {
            return new FormattedTextFrame(flags);
        }
    }
}